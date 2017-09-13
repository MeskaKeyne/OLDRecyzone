/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.gerantParc;

import Datas.DBNotification;
import controllers.main.ControllersMain;
import controllers.main.ControllersStatistique;
import exceptions.DataException;
import static exceptions.Message.ERROR_NOTIFICATION;
import static exceptions.Message.NOTIFICATION_DELETE_OK;
import helmo.nhpack.NHPack;
import java.text.ParseException;
import java.util.ArrayList;
import models.utilisateurs.URecyzone;
import models.gestion.Notification;

/**
 *
 * @author Lz
 */
public class ControllersGerantParc extends ControllersMain {
    
    private ArrayList<Notification> listeNotification;
    private boolean visible;
 
    public ControllersGerantParc(){
            super();
            this.listeNotification = null;
    }
    public ControllersGerantParc(URecyzone token) throws ParseException{
        super(token);
        this.listeNotification = new DBNotification().readPourParc(token.getID_PARC());
        this.visible = !(this.listeNotification == null);
    }
    public ArrayList<Notification> getNotification(){return this.listeNotification;}
    public void cloturer() {
        ArrayList<Notification> temp = new ArrayList(this.listeNotification);
        try {
            DBNotification request = new DBNotification();
            for (Notification n : this.listeNotification) {
                if (n.getCloturer()) {
                    if (request.supprimer(n))temp.remove(n);
                }
            }
            if(temp.size() == this.listeNotification.size()) throw new DataException(ERROR_NOTIFICATION);
            else{
                    this.confirmation(NOTIFICATION_DELETE_OK);
                    this.listeNotification = temp;
            }
        } catch (DataException err) {this.afficherErreur(err);}  
    }
    public void statistiques(){
        NHPack.getInstance().loadWindow("views.Statistiques.xml", new ControllersStatistique((URecyzone)this.token())); 
        NHPack.getInstance().showWindow("views.Statistiques.xml");
    }
    public void occupation(){
        NHPack.getInstance().loadWindow("views.OccupationConteneur.xml", new ControllersOccupationConteneur((URecyzone)this.token())); 
        NHPack.getInstance().showWindow("views.OccupationConteneur.xml");
    }
    public void setVisible(boolean state){this.visible = state;}
    public boolean getVisible(){return this.visible;}
    @Override public void disconnect() {
        NHPack.getInstance().closeWindow("views.GerantParc.xml");
        this.reconnect();
    }
}
    
