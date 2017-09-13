/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.menage;

import Datas.DBFacture;
import controllers.main.ControllersMain;
import exceptions.DataException;
import static exceptions.Message.ERROR_PAY_EVEN;
import static exceptions.Message.PAY_OK;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import java.util.Iterator;
import models.gestion.DetailsFacture;
import models.gestion.Facture;
import models.utilisateurs.Menage;


public class ControllersDetailsFacture extends ControllersMain {
    private final ArrayList<DetailsFacture> DETAILS;
    private final Facture FACTURE;
    private boolean visible;

    public ControllersDetailsFacture(){
        this.DETAILS=null;
        this.FACTURE=null;
    }
    public ControllersDetailsFacture(Menage token, ArrayList<DetailsFacture> myDetails, Facture myFacture){
        super(token);
        this.DETAILS=myDetails;
        this.FACTURE=myFacture;
        this.visible=!myFacture.estPayer();
    }
    public String getShow() {
        String out = "";
        out += "<html><body>";
        out += "<center><b>" + "Facture n° " + this.FACTURE.getId() + " du " + this.FACTURE.getDateFacture() + "</b></center><br><br>";
        out += "<center><b>" + "Statut " + this.FACTURE.getStatut() + "</b></center><br><br>";
        out += "<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Type</th><th>Type de dechet</th><th>Quantite</th><th>Montant</th></tr>";
        for (Iterator<DetailsFacture> it = this.DETAILS.iterator(); it.hasNext();) {
            DetailsFacture df = it.next();
            out += df;
        }
        out += "</table></center><br><br>";
        out += "<align=right><b>TOTAL: " + FACTURE.getMontant() + " euro(s)" + "</b></align></body></html>";
        return out;
    }
    public void payer(){
        try{
            DBFacture request = new DBFacture();
            if(this.FACTURE.estPayer())throw new DataException(ERROR_PAY_EVEN);
            if(request.pay(FACTURE.getId())) this.confirmation(PAY_OK);   
        }catch(DataException err){this.afficherErreur(err);}
        this.FACTURE.fairePayement(true);
        this.visible=false;
        NHPack.getInstance().refreshWindow("views.DetailsFacture.xml");
        NHPack.getInstance().refreshWindow("views.Factures.xml");
    }
    public boolean getVisible(){return this.visible;}
    @Override public void disconnect(){NHPack.getInstance().closeWindow("views.DetailsFacture.xml");}
        
    
}
