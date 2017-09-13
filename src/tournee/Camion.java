package tournee;

import Datas.IData;
import java.util.ArrayList;
import models.gestion.Conteneur;

/**
 *
 * @author clement
 */
public class Camion implements IData{
    private float ContenanceRestante;
    private  final ArrayList<Conteneur> LISTE;
    private float priority;

    public Camion() {
        this.ContenanceRestante = 80.0f;
        this.LISTE = new ArrayList<>();
    }
    public Camion(Conteneur c){
        this.ContenanceRestante = 80.0f-c.vUsed();
        this.LISTE = new ArrayList<>();
        if(c.vUsed()<=80.0f) this.LISTE.add(c);
        this.priority=c.getTauxRemplissage();     
    }
    public boolean ajouterConteneur(Conteneur conteneur){
       if(this.LISTE.isEmpty() ||(this.ContenanceRestante>=conteneur.vUsed() && conteneur.idDechet() == this.typeDechet()) ){
           this.ContenanceRestante -= conteneur.vUsed();
           return this.LISTE.add(conteneur);
       }else return false;
    }
    public int typeDechet(){return this.LISTE.get(0).idDechet();}
    public ArrayList<Conteneur> getListeConteneur(){return this.LISTE;}
    public float getCapaciteUsed(){return 80.0f-this.ContenanceRestante;}
    @Override public String toString(){
        String out ="<html><body><br><br>";
        out+="<font size= 4><b>" + DB_DECHET.get(this.typeDechet())+"</b> " + (80.0-this.ContenanceRestante)+" m³</font><br>";
        out = LISTE.stream().map((c) -> "<br><b>----- "+c.getAdresse()+" <font color=red>"+c.getTauxRemplissage()+"%</font> --- C:"+c.getConteneur()+"</b><br>").reduce(out, String::concat);
        return out;
    }
    public float getPriority(){return this.priority;}
}
