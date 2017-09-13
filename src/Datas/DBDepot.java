/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;

import exceptions.DataException;
import static exceptions.Message.ERROR_DECHET;
import static exceptions.Message.ERROR_DEPOT;
import static exceptions.Message.ERROR_DEPOT_DATE;
import java.util.ArrayList;
import java.util.HashMap;
import models.gestion.Dechet;
import models.gestion.Depot;
import models.gestion.Poubelles;

/**
 *
 * @author Lz
 */
public class DBDepot extends DBConnect implements IData {
    public HashMap readList() {
        try {
            String result[][] = this.bdd().createStatement("SELECT * FROM typeDechet")
                    .executeQuery();
            if (result == null){throw new DataException(ERROR_DECHET);}
            this.closeSession();
           ArrayList<Dechet> list = new ArrayList();
            for (String[] req : result) {list.add(new Dechet(this.formatQuery(req)));}
            System.out.print("");
            HashMap mapDechet=new HashMap();
            for(Dechet d : list) mapDechet.put(d.idDechet(), d);
            return mapDechet;
        } catch (DataException err){this.traiterErreur(err);}
        return null;
    }   
    public void Depot(Depot myDepot) throws DataException{
        String result[][]=null;
                this.bdd().openTransaction();
        int rowAffected = this.bdd().createStatement("INSERT INTO DEPOT (Date, IdMenage)"
                + " VALUES (GETDATE(), @idMenage)")
                .bindParameter("@idMenage", myDepot.getID_MENAGE())
                .executeUpdate();
        if(rowAffected == 1) result = this.bdd().createStatement("SELECT MAX(IdDepot) FROM DEPOT").executeQuery();
        else this.closeTransaction(new DataException(ERROR_DEPOT_DATE));
       if(result !=null){
           for(Poubelles req: myDepot.getDETAILS()){
               rowAffected = this.bdd().createStatement("INSERT INTO CONCERNER(IdDepot, IdTypeDechet, Volume, IdParcConteneur) "
                + "VALUES ( @idDepot, @idDechet, @Volume, @idParc)")
                .bindParameter("@idDepot", Integer.parseInt(result[0][0]))
                .bindParameter("@idDechet", req.idDechet())
                .bindParameter("@Volume", req.getVolumeDepose())
                .bindParameter("@idParc", req.idParc())
                .executeUpdate();
               if(rowAffected == 0) this.closeTransaction(new DataException(String.format("Le conteneur %s est plein !", DB_DECHET.get(req.idDechet()))));
           }
       }
       else this.closeTransaction(new DataException(ERROR_DEPOT));
        if(rowAffected == 1) this.closeTransaction();
    }
    private HashMap formatQuery(String data[]){
        HashMap req=new HashMap();
        req.put("id", Integer.parseInt(data[0]));
        req.put("nom", data[1]);
        if(data[2] == null) req.put("quotaAnnuel", (float)0);
        else req.put("quotaAnnuel", Float.parseFloat(data[2]));
        return req;
    }
    
}
