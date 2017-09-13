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
public class Facture {
    private final int ID;
    private final Date DATE;
    private final int ECHEANCE;
    private final float MONTANT;
    private boolean statut;
    private final int ID_MENAGE;
    
    public Facture(HashMap data){
        this.ID=(int)data.get("id");
        this.DATE=(Date)data.get("date");
        this.ECHEANCE=(int)data.get("dateEcheance");
        this.MONTANT=(float)data.get("montant");
        this.statut=(boolean)data.get("statut");
        this.ID_MENAGE=(int)data.get("idMenage");
    }
    public int getId(){ return this.ID;}
    public String getDateFacture(){return Validator.dateToString(this.DATE);}
    public float getMontant(){return this.MONTANT;}
    public String getStatut(){
        if(this.statut) return "PAYE";
        return "NON PAYE";
    }
    public boolean estPayer(){return this.statut;}
    public String getEcheance(){
        if(!this.statut) return "Dans "+this.ECHEANCE+" jours";
        return"";
    }
    public void fairePayement(boolean p){this.statut=p;}
    
    
}
