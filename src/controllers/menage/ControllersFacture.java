/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.menage;

import controllers.main.ControllersMain;
import exceptions.DataException;
import exceptions.Message;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import java.util.HashMap;
import models.gestion.DetailsFacture;
import models.gestion.Facture;
import models.utilisateurs.Menage;

/**
 *
 * @author Lz
 */
public class ControllersFacture extends ControllersMain {
    private final ArrayList<Facture> VALUES;
    private Facture factureSelected;
    private HashMap FACTURES;
    
    public ControllersFacture(){
        super();
        this.VALUES = null;
        this.factureSelected=null;
        this.FACTURES=null;
    }
    public ControllersFacture(Menage token){
        super(token);
        if(token.getFACTURES()!=null){
            this.VALUES = new ArrayList(token.getFACTURES().keySet());
            this.factureSelected=this.VALUES.get(0);
            return;
        }
        this.VALUES=null;
        this.factureSelected=null;
    }
    public ArrayList<Facture> getFactures(){return this.VALUES;}
    public void setSelection(ArrayList<Facture> f){this.factureSelected=f.get(0);}
    public void detail(){
        try{
                if(this.factureSelected==null)throw new DataException(Message.ERROR_READ_FACTURE);
                 NHPack.getInstance().loadWindow("views.DetailsFacture.xml", new ControllersDetailsFacture((Menage)super.token(), (ArrayList<DetailsFacture>)this.FACTURES.get(this.factureSelected), this.factureSelected));
                 NHPack.getInstance().showWindow("views.DetailsFacture.xml");
        /* NOTE: Pas opti comme constrcteur mais c est juste pour correspondre a la vue */
        } catch (DataException ex){this.afficherErreur(ex);}

    }
    @Override public void disconnect(){NHPack.getInstance().closeWindow("views.Factures.xml");}
    
}
