/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.gestion;

import Datas.IData;
import java.util.HashMap;

/**
 *
 * @author Lz
 */
public class Conteneur implements IData{

    private final int ID;
    private final int EMPLACEMENT;
    private final float CAPACITE;
    private final float VUSED;
    private float remplissage;
    private Dechet dechet;
    private final int ID_PARC;
    private final String ADRESSE;
    private boolean state;
    
    public Conteneur(){
        this.ID=-1;
        this.EMPLACEMENT=-1;
        this.CAPACITE=-1;
        this.remplissage=-1;
        this.dechet=null;
        this.ID_PARC=-1;
        this.dechet=null;
        this.ADRESSE=null;
        this.VUSED = Float.NaN;
        this.state = false;
    }
    public Conteneur(HashMap data){
        this.ID=(int)data.get("idConteneur");
        this.ADRESSE=(String)data.get("adresse");
        this.EMPLACEMENT=(int)data.get("emplacement");
        this.CAPACITE=(float)data.get("volume");
        this.remplissage=(float)data.get("tauxRemplissage");
        this.dechet=new Dechet((Dechet)DB_DECHET.get((int)data.get("idTypeDechet")));
        this.ID_PARC=(int)data.get("idParcConteneur");
        this.VUSED=(float)data.get("vUsed");
        this.state=false;
    }
    
    public String getAdresse(){return this.ADRESSE;}
    public String getNom(){return this.dechet.getTypeDeDechet();}
    public int idDechet(){ return this.dechet.idDechet();}
    public float getTauxRemplissage(){return this.remplissage;}
    public float vUsed(){ return this.VUSED;}
    public boolean getVider(){return this.state;}
    public void setVider(boolean state){this.state = state;}
    public int getConteneur(){return this.ID;}
    @Override public String toString(){
            String out="";
            out+="<tr>";
            out += "<td><center>" + this.ID + "</center></td>";
            out += "<td><center>" + this.getNom() + "</center></td>";
            out += "<td><center>" + this.CAPACITE + " m³" + "</center></td>";
            out += "<td><center>" + this.remplissage + " %"+ "</center></td>";
            out+="</tr>";
            return out;
    }
    
    
    
}
