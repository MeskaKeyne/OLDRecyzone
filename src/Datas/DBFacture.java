/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;

import exceptions.DataException;
import static exceptions.Message.ERROR_PAY_FACTURE;
import static exceptions.Message.ERROR_READ_FACTURE;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import models.gestion.DetailsFacture;
import models.gestion.Facture;
import tools.Validator;

/**
 *
 * @author Lz
 */
public class DBFacture extends DBConnect {
    
  public HashMap read(int idMenage){
      String result[][] = this.bdd().createStatement("SELECT IdFacture, DateFacture, DATEDIFF( day, DateFacture, DateEcheance ), Montant, StatutPayement, IdMenage"
                                                     + " FROM FACTURE"
                                                     + " WHERE idMenage = @idMenage")
                                                     .bindParameter("@idMenage", idMenage)
                                                     .executeQuery();
      if(result.length == 0) return null; // il n existe pas de facture
      HashMap mapFacture=new HashMap();
      for(String[] req: result){
          Facture myFacture =new Facture(this.formatQuery(req));
          String resultDetail[][]= this.bdd().createStatement("SELECT *"
                                                              + " FROM DETAILFACTURE"
                                                              + " WHERE idFacture = @idFacture")
                                                              .bindParameter("@idFacture", myFacture.getId())
                                                              .executeQuery();
         
          if(resultDetail.length == 0) try {
              throw new DataException(ERROR_READ_FACTURE);
          } catch (DataException ex){this.traiterErreur(ex);}
          ArrayList<DetailsFacture> fd= new ArrayList();
          for(String[] reqs :resultDetail){fd.add(new DetailsFacture(this.dformatQuery(reqs)));}
          mapFacture.put(myFacture, fd);   
      }
      this.closeSession();
      return mapFacture;
  }
  public boolean pay(int idFacture) throws DataException{
      this.bdd().openTransaction();
      int rowAffected = this.bdd().createStatement("UPDATE FACTURE "
              + " SET StatutPayement ='P' "
              + " WHERE idFacture = @idFacture")
              .bindParameter("@idFacture", idFacture)
              .executeUpdate();
      if(rowAffected == 0){
          this.bdd().rollback();
          throw new DataException(ERROR_PAY_FACTURE);
      }
      this.bdd().commit();
      return true;
      
  }
  public int generer(){
      int row = this.maxId();
      this.bdd().executeQuery(String.format("EXECUTE genererFacture"));
      return this.maxId()-row;
      
  }
  private int maxId(){
      String[][] result = this.bdd().createStatement("SELECT MAX(IdFacture) "
                                                    +" FROM FACTURE ")
                                                    .executeQuery();
      if(result.length>0){
          if(result[0][0] == null) return 0;
          return Integer.parseInt(result[0][0]);
      }
      return 0;
              
  }
   private HashMap formatQuery(String[] req) {
        HashMap data = new HashMap();
        data.put("id", Integer.parseInt(req[0]));
        data.put("date", Validator.stringToDate(req[1]));
        data.put("dateEcheance", Integer.parseInt(req[2]));
        data.put("montant", Float.parseFloat(req[3]));
        if (req[4].contains("N"))data.put("statut", false);
        else data.put("statut", true);
        data.put("idMenage", Integer.parseInt(req[5]));
        return data;
    }
    private HashMap dformatQuery(String[] req) {
        HashMap data = new HashMap();
        data.put("id", Integer.parseInt(req[0]));
        if(req[1] == null)data.put("quantite",(float)0.0);
        else data.put("quantite", Float.parseFloat(req[1]));
        data.put("type", req[2]);
        data.put("montant", Float.parseFloat(req[3]));
        data.put("idDechet", Integer.parseInt(req[4]));
        return data;
    }

}
