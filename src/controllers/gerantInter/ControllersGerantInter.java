/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.gerantInter;

import Datas.DBConteneur;
import Datas.DBFacture;
import controllers.main.ControllersMain;
import controllers.main.ControllersStatistique;
import exceptions.DataException;
import static exceptions.Message.ERROR_READ_TOURNE;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import models.gestion.Conteneur;
import models.utilisateurs.URecyzone;
import tournee.Camion;
import tournee.Tournee;

/**
 *
 * @author Lz
 */
public class ControllersGerantInter extends ControllersMain {
    private ArrayList<Conteneur> LISTE_CONTENEUR;
    private boolean visible;

    public ControllersGerantInter(){super();}
    public ControllersGerantInter(URecyzone token){
        super(token);
        DBConteneur request = new DBConteneur();
      this.visible=!((this.LISTE_CONTENEUR = request.readFull()) == null);
    }
    public void genererTournee(){
        try {
            ArrayList<Camion> tournee = Tournee.generer(LISTE_CONTENEUR, 4);
            if(!tournee.isEmpty()){
                NHPack.getInstance().loadWindow("views.Tournee.xml", new ControllersTournee((URecyzone)this.token(), tournee, LISTE_CONTENEUR));
                NHPack.getInstance().showWindow("views.Tournee.xml");
            }else throw new DataException(ERROR_READ_TOURNE);
        } catch (DataException ex) {
          this.afficherErreur(ex);
        }
    }
        
    public ArrayList<Conteneur> getListeConteneur(){return this.LISTE_CONTENEUR;}
    public void statistiques(){
        NHPack.getInstance().loadWindow("views.Statistiques.xml", new ControllersStatistique((URecyzone)this.token())); 
        NHPack.getInstance().showWindow("views.Statistiques.xml");
    }
    @Override public void disconnect() {
        NHPack.getInstance().closeWindow("views.GerantInter.xml");
        this.reconnect();
    }
    public boolean getVisible(){return this.visible;}
    public void setVisible(boolean state){this.visible= state;}
    public void genererFacture(){
        DBFacture request = new DBFacture();
        int i = request.generer();
        if(i>0) NHPack.getInstance().showInformation("SUCCESS", String.format("%d facture(s) ont été envoyes", i));
        else NHPack.getInstance().showInformation("SUCCESS", String.format("Pas de facture à envoyer"));
    }
    
    
}
