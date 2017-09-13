/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.menage;

import Datas.DBQuota;
import Datas.DBUtilisateur;
import controllers.main.ControllersMain;
import exceptions.DataException;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import models.utilisateurs.Menage;
import views.models.QuotasActuel;

/**
 *
 * @author Lz
 */
public class ControllersMenage extends ControllersMain {
    private boolean visible;
    
    public ControllersMenage(){}
    public ControllersMenage(Menage m){
        super(m);
        this.visible = !(m.getFACTURES() == null);
    }
  
    public String getInformation() throws DataException{
        DBUtilisateur request = new DBUtilisateur();
        String out="";
        out+=(Menage)this.token()+"<br>";
        out+="<b>Votre derniere visite :  </b>"+ request.readLastVisite(this.getId())+"<br><br>";
        out+=this.getQuotaActuel();
        return out;
    }
    public String getQuotaActuel() throws DataException{
        DBQuota request = new DBQuota();
        ArrayList<QuotasActuel> list=request.read(this.getId());
        String out="";
        out+="<html><body>";
        out+="<center><b> Vos Quotas Actuels</b></center><br><br><br>";
        out+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Type de Dechet</th><th>Volume depose</th><th>Volume autorisé</th><th>Reste</th></tr>";
        out = list.stream().map((qa) -> ""+qa).reduce(out, String::concat);
        out+="</table></center></body></html>";
        return out;
    }
    public void voirFacture(){
       NHPack.getInstance().loadWindow("views.Factures.xml", new ControllersFacture((Menage)super.token())); 
       NHPack.getInstance().showWindow("views.Factures.xml");
    }
    public boolean getVisible(){return this.visible;}
    public void setVisible(boolean v){this.visible=v;}

    @Override public void disconnect(){
        NHPack.getInstance().closeWindow("views.menage.xml");
        this.reconnect();
    }
}
