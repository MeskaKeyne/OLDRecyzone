/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers.main;

import Datas.DBStats;
import Datas.IData;
import helmo.nhpack.NHPack;
import java.util.ArrayList;
import models.gestion.Dechet;
import models.utilisateurs.URecyzone;

/**
 *
 * @author Lz
 */
public class ControllersStatistique extends ControllersMain implements IData{
    
    private final ArrayList<String> PERIODE;
    private final ArrayList<Dechet> DECHET;
    private Dechet dechet;
    private int cPeriode;
    private int type;
    private boolean checkVisite;
    private boolean checkVolume;
    private String periode;
    private final int ID_PARC;
    private String tableau;
    private boolean visible;
    
    public ControllersStatistique(){
        super();
        this.PERIODE = null;
        this.DECHET = null;
        this.ID_PARC=-1;
    }
    public ControllersStatistique(URecyzone token){
       
        super(token);
        this.ID_PARC=token.getID_PARC();
        this.PERIODE=new ArrayList();
        this.PERIODE.add("Journalier");
        this.PERIODE.add("Mensuel");
        this.DECHET=new ArrayList(DB_DECHET.values());
        this.DECHET.add(new Dechet());
        this.dechet=this.DECHET.get(0);
        this.periode="J";
        this.type=1;
        this.visible = false;
    }
    public ArrayList<String> getBoxPeriode(){return this.PERIODE;}
    public String getPeriode(){return this.periode;}
    public void setPeriode(String myChoice){
        if(myChoice.contains("J")) this.cPeriode=1;
        else this.cPeriode = 2;
    }
    public boolean getVisible(){return this.visible;}
    public void setVisible(boolean state){this.visible = state;}
    public boolean getVisite(){return this.checkVisite;}
    public boolean getVolumeDechet(){return this.checkVolume;}
    public void setVisite(boolean state){this.checkVisite=state;}
    public void setVolumeDechet(boolean state){this.checkVolume=state;}
    public void type(){
        if(this.checkVisite){
            this.type = 1;
            this.visible = false;
        } else {
            this.type = 2;
            this.visible = true;
        }
    }
    public ArrayList<Dechet> getBoxDechet(){return this.DECHET;}
    public Dechet getDechet(){return this.dechet;}
    public void setDechet(Dechet dechet){this.dechet = dechet;}
    public void generer(){
        this.tableau="<html><body>";
        DBStats request =new DBStats();
        switch (this.ID_PARC) {
            case 0:
                if (this.type == 1) {
                    if (cPeriode == 1) {
                        this.tableau += "<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Nombre de visites moyennes</th></tr>";
                        for (String[] line : request.visiteParJour())this.tableau += "<tr><td><center>" + line[1] + "</center></td><td><center>" + line[0] + "</center></td></tr>";
                    } else {
                        this.tableau += "<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Nombre de visites moyennes</th></tr>";
                        for (String[] line : request.visiteParMois())this.tableau += "<tr><td><center>" + line[1] + "</center></td><td><center>" + line[0] + "</center></td></tr>"; 
                    }
                }else{
                        if(this.dechet.idDechet() == -1){
                            if(cPeriode == 1){
                                this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Volume moyen</th></tr>";
                                for(String[] line: request.volumeParJour())this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        } else {
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Volume moyen</th></tr>";
                            for(String[] line: request.volumeParMois())this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        }
                    }else{
                            if(cPeriode == 1){
                                this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Volume moyen pour "+ this.dechet.getTypeDeDechet() +"</th></tr>";
                                for(String[] line: request.volumeDechetParJour(this.dechet.idDechet()))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        } else {
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Volume moyen pour "+ this.dechet.getTypeDeDechet() +"</th></tr>";
                            for(String[] line: request.volumeDechetParMois(this.dechet.idDechet()))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        }
                        
                    }
                }
            break;
                
            default:    
                if(this.type == 1){
                    if(cPeriode == 1){
                        this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Nombre de visites moyennes</th></tr>";
                        for(String[] line: request.visiteParJour(this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"</center></td></tr>";    
                    }else{
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Nombre de visites moyennes</th></tr>";
                            for(String[] line: request.visiteParMois(this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"</center></td></tr>";     
                    }
                }else{
                    if(this.dechet.idDechet() == -1){
                        if(cPeriode == 1){
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Volume moyen</th></tr>";
                            for(String[] line: request.volumeParJour(this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        } else {
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Volume moyen</th></tr>";
                            for(String[] line: request.volumeParMois(this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        }
                    }else{
                            if(cPeriode == 1){
                                this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Jour</th><th>Volume moyen pour "+ this.dechet.getTypeDeDechet() +"</th></tr>";
                                for(String[] line: request.volumeDechetParJour(this.dechet.idDechet(), this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        } else {
                            this.tableau+="<center><table width=400px bgcolor= #ffffff border = 1 bordercolor= #000000><tr><th>Mois</th><th>Volume moyen pour "+ this.dechet.getTypeDeDechet() +"</th></tr>";
                            for(String[] line: request.volumeDechetParMois(this.dechet.idDechet(), this.ID_PARC))this.tableau+="<tr><td><center>"+line[1]+"</center></td><td><center>"+line[0]+"  m³</center></td></tr>";    
                        }
                        
                    }
                }
        }
        this.tableau+="</table></body></html>";
    }
    public String getStatistique(){return this.tableau;}     
    @Override public void disconnect() { NHPack.getInstance().closeWindow("views.Statistiques.xml");}
    
}
