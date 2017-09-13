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
public class DetailsFacture implements IData{
    private final int ID;
    private final float QUANTITE;
    private final String TYPE;
    private final float MONTANT;
    private final int ID_DECHET;

    public DetailsFacture(HashMap data) {
        this.ID=(int)data.get("id");
        this.QUANTITE=(float)data.get("quantite");
        this.TYPE=(String)data.get("type");
        this.MONTANT=(float)data.get("montant");
        this.ID_DECHET=(int)data.get("idDechet");
    }
        @Override public String toString(){
            Dechet dechet= (Dechet)DB_DECHET.get(this.ID_DECHET);
            String out="";
            out+="<tr>";
            out += "<td><center>" + this.TYPE + "</center></td>";
            out += "<td><center>" + dechet.getTypeDeDechet() + "</center></td>";
            if(this.QUANTITE == 0) out += "<td><center>" +" "+ "</center></td>";
            else out += "<td><center>" + this.QUANTITE + " m³" + "</center></td>";
            out += "<td><center>" + this.MONTANT + " euro(s)"+ "</center></td>";
            out+="</tr>";
            return out;
        }
        public float montant(){return this.MONTANT;}
    
}
