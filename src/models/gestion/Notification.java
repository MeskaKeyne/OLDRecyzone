/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.gestion;

import java.util.Date;
import java.util.HashMap;
import tools.Validator;

/**
 *
 * @author Lz
 */
public class Notification {
        final private int ID;
        final private Date DATE;
        final private String TXT;
        final private int ID_MENAGE;
        final private int ID_CONTENEUR;
        private boolean etat;
          
        public Notification(HashMap data){
            this.ID=(int)data.get("id");
            this.DATE=(Date)data.get("date");
            this.TXT=(String)data.get("txt");
            this.ID_MENAGE=(int)data.get("idMenage");
            this.ID_CONTENEUR=(int)data.get("idConteneur");
            this.etat = false;     
        }
        @Override public String toString(){
            String out="";
            out+="<tr>";
            out += "<td>" + Validator.dateToString(this.DATE) + "</td>";
            out += "<td>" + this.TXT + "</td>";
            out+="</tr>";
            return out;
        }
        public String getDate(){return  Validator.dateToString(this.DATE);}
        public String getNotifications(){return this.TXT;}
        public void setCloturer(boolean etat){this.etat=etat;}
        public boolean getCloturer(){return this.etat;}
        public int id(){return this.ID;}
}
