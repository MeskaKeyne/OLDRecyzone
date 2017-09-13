/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;

/**
 *
 * @author Lz
 */
public class DBStats extends DBConnect {
    
    
    public String[][] visiteParJour(int idParc){
        String[][] result = this.bdd().createStatement("SELECT *  "
                                                       +"FROM statistiqueVisiteJourParc "
                                                       +"WHERE idParcConteneur = @idParc "
                                                       +"ORDER BY idJour")
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] visiteParJour(){
        String[][] result = this.bdd().createStatement("SELECT *  "
                                                       +"FROM statistiqueVisiteJourInter "
                                                       +"ORDER BY idJour")
                                                       .executeQuery();
         this.closeSession();
        return result;
    }
    public String[][] visiteParMois(int idParc){
        String[][] result = this.bdd().createStatement("SELECT *  "
                                                       +"FROM statistiqueVisiteMoisParc "
                                                       +"WHERE idParcConteneur = @idParc "
                                                       +"ORDER BY idMois")
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] visiteParMois(){
        String[][] result = this.bdd().createStatement("SELECT *  "
                                                       +"FROM statistiqueVisiteMoisInter "
                                                       +"ORDER BY idMois")
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeParJour(){
        String[][] result = this.bdd().createStatement(" SELECT *  "
                                                       +"FROM statistiqueVolumeJourInter "
                                                       +"ORDER BY idJour")
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeParJour(int idParc){
        String[][] result = this.bdd().createStatement(" SELECT *  "
                                                       +"FROM statistiqueVolumeJourParc "
                                                       +"WHERE idParcConteneur = @idParc "
                                                       +"ORDER BY idJour")
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeParMois(int idParc){
        String[][] result = this.bdd().createStatement(" SELECT *  "
                                                       +"FROM statistiqueVolumeMoisParc "
                                                       +"WHERE idParcConteneur = @idParc "
                                                       +" ORDER BY idMois")
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeParMois(){
        String[][] result = this.bdd().createStatement(" SELECT *  "
                                                       +"FROM statistiqueVolumeMoisInter "
                                                       + "ORDER BY idMois")
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeDechetParJour(int idDechet){
        String[][] result = this.bdd().createStatement(" SELECT * "
                                                       + "FROM statistiqueVolumeJourInterDechet "
                                                       + "WHERE idDechet=@idDechet "
                                                       + " ORDER BY idJour ")
                                                       .bindParameter("@idDechet", idDechet)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
    public String[][] volumeDechetParMois(int idDechet){
        String[][] result = this.bdd().createStatement(" SELECT * "
                                                       + "FROM statistiqueVolumeMoisInterDechet "
                                                       + "WHERE idDechet=@idDechet "
                                                       + " ORDER BY idMois ")
                                                       .bindParameter("@idDechet", idDechet)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }

    public String[][] volumeDechetParJour(int idDechet, int idParc) {
        String[][] result = this.bdd().createStatement(" SELECT * "
                                                       + "FROM statistiqueVolumeJourParcDechet "
                                                       + "WHERE idDechet=@idDechet "
                                                       + "AND idParcConteneur = @idParc "
                                                       + " ORDER BY idJour ")
                                                       .bindParameter("@idDechet", idDechet)
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }

    public String[][] volumeDechetParMois(int idDechet, int idParc) {
        String[][] result = this.bdd().createStatement(" SELECT * "
                                                       + "FROM statistiqueVolumeMoisParcDechet "
                                                       + "WHERE idDechet=@idDechet "
                                                       + "AND idParcConteneur = @idParc "
                                                       + " ORDER BY idMois ")
                                                       .bindParameter("@idDechet", idDechet)
                                                       .bindParameter("@idParc", idParc)
                                                       .executeQuery();
        this.closeSession();
        return result;
    }
}
