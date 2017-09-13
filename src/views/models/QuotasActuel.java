/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package views.models;

import java.util.HashMap;

/**
 *
 * @author Lz
 */
public class QuotasActuel {
    final private String TYPE_DECHET;
    final private float VOLUME_DEPOSE;
    final private float VOLUME_AUTHORIZED;
    final private float RESTE;
    
    public QuotasActuel(HashMap data){
        this.TYPE_DECHET=(String)data.get("typeDechet");
        this.VOLUME_AUTHORIZED=(float)data.get("volumeAuthorized");
        this.VOLUME_DEPOSE=(float)data.get("volumeDepose");
        this.RESTE=(float)data.get("reste");
    }
    public String getTYPE_DECHET() {return TYPE_DECHET;}
    public float getVOLUME_DEPOSE(){return VOLUME_DEPOSE;}
    public float getVOLUME_AUTHORIZED(){return VOLUME_AUTHORIZED;}
    public float getRESTE(){return RESTE;}
    @Override public String toString(){
        String out = "";
        out += "<tr>";
        out += "<td>" + this.TYPE_DECHET + "</td>";
        out += "<td>" + this.VOLUME_DEPOSE + " m³</td>";
        out += "<td>" + this.VOLUME_AUTHORIZED + " m³</td>";
        out += "<td>" + this.RESTE + " m³</td>";
        out += "</tr>";
        return out;
    }
}
