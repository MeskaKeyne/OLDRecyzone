
package models.utilisateurs;

import Datas.DBFacture;
import Datas.DBNotification;
import exceptions.DataException;
import static exceptions.Message.ERROR_ADULTE;
import static exceptions.Message.ERROR_ENFANT;
import java.text.ParseException;
import java.util.HashMap;
import models.coordonnees.Adresse;
import models.gestion.Notification;


public class Menage extends Personne {
    
    private int nbEnfants;
    private int nbAdultes;
    private Adresse residence;
    private final HashMap FACTURES;
    private final Notification NOTIFICATION;

    public Menage(){
        super();
        this.FACTURES = null;
        this.NOTIFICATION = null;
    }
    public Menage(HashMap data) throws ParseException{
        super(data);
        this.nbEnfants=(int)data.get("nbEnfants");
        this.nbAdultes=(int)data.get("nbAdultes");
        try {
            this.residence=new Adresse(data);
            this.checkingMenage();
        } catch (DataException ex) {System.out.println(ex.getMessage());}
        this.FACTURES = new DBFacture().read(this.getId());
        this.NOTIFICATION = new DBNotification().readPourMenage(this.getId());

    }
    public final void checkingMenage() throws DataException{
        if(this.nbAdultes <= 0) throw new DataException(ERROR_ADULTE);
        if(this.nbEnfants < 0) throw new DataException(ERROR_ENFANT);
    }
    public int getNbEnfants(){return this.nbEnfants;}
    public int getNbAdultes(){return this.nbAdultes;}
    public String getRue(){return this.residence.getRUE();}
    public int getNumero(){return this.residence.getNUMERO();}
    public String getLocalite(){return this.residence.getLOCALITE();}
    public String getBoite(){return this.residence.getBOITE();}
    @Override public int getIdCommune(){return this.residence.getID_COMMUNE();}
    public int getCodePostal(){return this.residence.getCODE_POSTAL();}
    public HashMap getFACTURES(){
        return this.FACTURES;
    }
    @Override public String toString(){
        String out ="";
        out+="<html><body><br>";
        out+=String.format("<b>Adresse </b> %s<br>", this.residence);
        out+="<size=14><b>Composition du menage</b><br>";
        out+=String.format("Adultes: <b>%s</b><br>", this.nbAdultes);
        out+=String.format("Enfants: <b>%s</b>", this.nbEnfants);
        out+="</size>";
        if(this.NOTIFICATION!=null)out+="<table><th><font color=red>"+ this.NOTIFICATION.getNotifications()+"</font></th></table>";
        return super.toString()+out;
    }    
}
