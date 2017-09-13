/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.gerantParc;

import Datas.DBConteneur;
import controllers.main.ControllersMain;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import models.utilisateurs.URecyzone;
import models.gestion.Conteneur;

public class ControllersOccupationConteneur extends ControllersMain {
    private final int ID_PARC;
 
    public ControllersOccupationConteneur(){
        super();
        this.ID_PARC= -1;
    }
    public ControllersOccupationConteneur(URecyzone token){
       super(token);
       this.ID_PARC=token.getID_PARC();
    }
    public String getOccupation() {
        ArrayList<Conteneur> liste = new DBConteneur().read(this.ID_PARC);
        String out = "";
        out += "<html><body>";
        out+="<center><b>"+liste.get(0).getAdresse()+"</b></center><br><br>";
        out += "<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Conteneur</th><th>Type de dechet</th><th>Volume</th><th>Remplissage</th></tr>";
        out = liste.stream().map((token) -> "" + token).reduce(out, String::concat);
        out += "</table></center></body></html>";
        return out;
    }
    @Override public void disconnect() {NHPack.getInstance().closeWindow("views.OccupationConteneur.xml");}
}
