/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;


import exceptions.DataException;
import static exceptions.Message.ERROR_DELETE_NOTIFICATION;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import tools.Validator;
import models.gestion.Notification;

public class DBNotification extends DBConnect {
    
    public ArrayList<Notification> readPourParc(int idParc) throws ParseException{
        String[][] result=this.bdd().createStatement(" SELECT n.*"
                                                    + " FROM NOTIFICATION n"
                                                    + " JOIN Conteneur c ON n.IdConteneur = c.IdConteneur"
                                                    + " JOIN ParcConteneur pc ON c.IdParcConteneur = pc.IdParcConteneur"
                                                    + " WHERE pc.IdParcConteneur= @idParc")
                                                    .bindParameter("@idParc", idParc)
                                                    .executeQuery();
        if(result.length>0){
            ArrayList<Notification> list=new ArrayList();
            for(String req[] : result){list.add(new Notification(this.formatQuery(req)));}
            return list;   
        }
        return null;
    }
    public Notification readPourMenage(int idMenage) throws ParseException{
        String[][] result=this.bdd().createStatement(" SELECT *"
                                                    + " FROM NOTIFICATION "
                                                    + " WHERE IdMenage= @idMenage")
                                                    .bindParameter("@idMenage", idMenage)
                                                    .executeQuery();
        if(result.length> 0) return new Notification(this.formatQuery(result[0]));   
        return null;
    }
    public boolean supprimer(Notification delete) throws DataException{
        int rowDelete = this.bdd().createStatement(" DELETE FROM NOTIFICATION "
                                                    + "WHERE IdNotification = @id")
                                                    .bindParameter("@id", delete.id())
                                                    .executeUpdate();
        if(rowDelete == 0) throw new DataException(ERROR_DELETE_NOTIFICATION);
        else return true;
    }
    HashMap formatQuery(String[] data){
        HashMap req=new HashMap();
        req.put("id", Integer.parseInt(data[0]));
        data[1]=data[1].substring(0,data[1].length()-2);
        req.put("date", Validator.stringToDate(data[1]));
        req.put("txt", data[2]);
        if(data[3]!=null)req.put("idMenage", Integer.parseInt(data[3]));
        else req.put("idMenage", 0);
       if(data[4]!=null)req.put("idConteneur", Integer.parseInt(data[4]));
        else req.put("idConteneur", 0);
        return req;
    }
    
}
