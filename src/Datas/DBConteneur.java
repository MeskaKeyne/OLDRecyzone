/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;

import exceptions.DataException;
import static exceptions.Message.ERROR_READ_CONTENEUR;
import static exceptions.Message.ERROR_UPDATE_CONTENEUR;
import java.util.ArrayList;
import java.util.HashMap;
import tools.ComparatorConteneurAlpha;
import models.gestion.Conteneur;
import tournee.Camion;

/**
 *
 * @author Lz
 */
public class DBConteneur extends DBConnect{
    
    public ArrayList<Conteneur> read(int idParc){
        String result[][] = this.bdd().createStatement("SELECT idConteneur, adresse, emplacement, volume, tauxRemplissage, idTypeDechet, idParcConteneur, vUsed"
                                    + " FROM detailConteneur"
                                    + " WHERE idParcConteneur = @idParc")
                                    .bindParameter("@idParc", idParc)
                                    .executeQuery();
        if(result.length == 0) try {
            throw new DataException(ERROR_READ_CONTENEUR);
        } catch (DataException ex) {this.traiterErreur(ex);}
        ArrayList<Conteneur> queue = new ArrayList();
        for(String[] req:result){queue.add(new Conteneur(this.formatQuery(req)));}
        queue.sort(new ComparatorConteneurAlpha());
        return queue;
    }
    public ArrayList<Conteneur> readFull(){
        String result[][] = this.bdd().createStatement("SELECT idConteneur, adresse, emplacement, volume, tauxRemplissage, idTypeDechet, idParcConteneur, vUsed"
                                                       + " FROM detailConteneur"
                                                       + " WHERE tauxRemplissage>=50.0 "
                                                       + " ORDER BY tauxRemplissage DESC")
                                                       .executeQuery();
        
        if(result.length == 0) return null;
        ArrayList<Conteneur> queue = new ArrayList();
        for(String[] req:result){queue.add(new Conteneur(this.formatQuery(req)));}
        return queue;
    }
    public int vider(Camion camion) throws DataException{
        int rowAffected = 0;
        int rowsAffected =0;
        this.bdd().openTransaction();
            for(Conteneur aVider: camion.getListeConteneur()){
                
                rowAffected=this.bdd().createStatement("UPDATE conteneur set volumeUtilise = 0 "
                        + "WHERE idConteneur = @idConteneur")
                        .bindParameter("@idConteneur", aVider.getConteneur())
                        .executeUpdate();
                System.out.println(rowAffected);
                if(rowAffected == 0){
                    this.bdd().rollback();
                    throw new DataException(ERROR_UPDATE_CONTENEUR);
                }else rowsAffected++;
        }
        this.bdd().commit();
        this.closeSession();
        return rowsAffected;
    }
    public HashMap formatQuery(String[] data){
        HashMap req = new HashMap();
        req.put("idConteneur", Integer.parseInt(data[0]));
        req.put("adresse", data[1]);
        req.put("emplacement", Integer.parseInt(data[2]));
        req.put("volume", Float.parseFloat(data[3]));
        req.put("tauxRemplissage", Float.parseFloat(data[4]));
        req.put("idTypeDechet", Integer.parseInt(data[5]));
        req.put("idParcConteneur", Integer.parseInt(data[6]));
        req.put("vUsed", Float.parseFloat(data[7]));
        return req;
        
    }
    
    
    ///
}
