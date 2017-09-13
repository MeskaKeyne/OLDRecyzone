/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.employe;

import Datas.DBNotification;
import controllers.main.ControllersMain;
import helmo.nhpack.NHPack;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.utilisateurs.URecyzone;
import models.gestion.Notification;

public class ControllersEmploye extends ControllersMain {
    private final ArrayList<Notification> notification;
    private boolean visible;

    public ControllersEmploye() {
      super();
      this.notification=null;
      this.visible =false;
      
    }
    public ControllersEmploye(URecyzone token){
        super(token);
        DBNotification request = new DBNotification();
        ArrayList<Notification> tmp=null;
        try {
            tmp=request.readPourParc(token.getID_PARC());
        } catch (ParseException ex){Logger.getLogger(ControllersEmploye.class.getName()).log(Level.SEVERE, null, ex);}
        this.visible=!((this.notification=tmp) == null);
 
    }
    public String getNotification(){
        String out="";
        out+="<html><body>";
        out+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Date</th><th>Notifications</th></tr>";
        if(this.notification !=null) out = this.notification.stream().map((token) -> ""+token).reduce(out, String::concat);
        out+="</table></center></body></html>";
        return out; 
    }
    public void nouvelleInscription() {
        NHPack.getInstance().loadWindow("views.InscriptionMenage.xml", new ControllersInscription((URecyzone)super.token()));
        NHPack.getInstance().showWindow("views.InscriptionMenage.xml");
    }
    public void encodageDepot() {
        NHPack.getInstance().loadWindow("views.Depot.xml", new ControllersDepot((URecyzone) super.token()));
        NHPack.getInstance().showWindow("views.Depot.xml");
    }
    public void setVisible(boolean state){this.visible=state;}
    public boolean getVisible(){return this.visible;}
    @Override public void disconnect() {
        NHPack.getInstance().closeWindow("views.Employe.xml");
        this.reconnect();
    }
    
}
