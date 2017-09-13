/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.gerantInter;

import Datas.DBConteneur;
import controllers.main.ControllersMain;
import exceptions.DataException;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import models.gestion.Conteneur;
import models.utilisateurs.URecyzone;
import tournee.Camion;

/**
 *
 * @author Lz
 */
public class ControllersTournee extends ControllersMain{
    private final ArrayList<Camion> TOURNE;
    private ArrayList<Conteneur> conteneur;

    public ControllersTournee(){
        super();
        this.TOURNE=null;   
    }
    public ControllersTournee(URecyzone token, ArrayList<Camion> aVider, ArrayList<Conteneur> c){
        super(token);
        this.TOURNE= aVider;
        this.conteneur=c;
    }
    public String getTournee(){
        int i=1;
        String out="<html><body>";
        for(Camion monCamion : this.TOURNE){
            out+="<center><p><font size = 4 color=green>Camion "+i+"</font>";
            out+=monCamion;
            out+="</p></center>";
            i++;
        }
        out+="</body></html>";
        return out;
    }
   
    public void vider(){
        try {
            DBConteneur request = new DBConteneur();
            int i=0;
            for(Camion aVider: this.TOURNE){
                i+=request.vider(aVider);
                aVider.getListeConteneur().stream().forEach((vide) -> {this.conteneur.remove(vide);});
            }
             NHPack.getInstance().showInformation("Success", String.format(" %d conteneur(s) ont été vidé(s)", i));
             NHPack.getInstance().refreshWindow("views.GerantInter.xml");
             NHPack.getInstance().closeWindow("views.Tournee.xml");
        } catch (DataException ex){this.afficherErreur(ex);}         
    }
    @Override public void disconnect() {}
    
}
