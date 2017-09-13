/**
 *      ControllersDepot
 *  Permet de gerer un depot de dechet
 * 
 *  @param String recherche Le champs recherche de la vue
 *  @param Menage menageSelected le menage selectione 
 *  @param ArrayList<Recherche> result contient les resultats de la recherche
 *  @param ArrayList<Dechet> listeDechet Contient la liste des dechets disponibles
 *  @param ArrayList<Depot> listeDepot Contient la liste des depots qu on veux enregistrer
 *                          en BDD
 *  @param Dechet dechet contient le dechet que l'ont veux encoder
 *  @param boolean visible Sert à savoir si le composant doit être visible ou pas
 *  @param float volume le volume que l'on veux encoder
 * 
 *  @author TUNSAJAN Somboom
 *  @since 12/05/15 (last modiffied 14/05/15)
 *  @version 1.4
 */
package controllers.employe;

import Datas.DBDepot;
import Datas.DBUtilisateur;
import Datas.IData;
import controllers.main.ControllersMain;
import exceptions.DataException;
import static exceptions.Message.DEPOT_OK;
import static exceptions.Message.ERROR_LIST_DEPOT;
import static exceptions.Message.ERROR_NOMBRE;
import static exceptions.Message.ERROR_RECHERCHE;
import static exceptions.Message.ERROR_SELECT_DECHET;
import static exceptions.Message.ERROR_SELECT_MENAGE;
import helmo.nhpack.NHPack;
import java.text.ParseException;
import java.util.ArrayList;
import models.utilisateurs.Menage;
import models.utilisateurs.URecyzone;
import tools.Validator;
import models.gestion.Dechet;
import models.gestion.Depot;
import models.gestion.Poubelles;
import views.models.Recherche;

public class ControllersDepot extends ControllersMain implements IData{
    private String recherche;
    private Recherche menageSelected;
    private ArrayList<Recherche> result;
    private ArrayList<Dechet> ListeDechet;
    private ArrayList<Poubelles> listeDetails;
    private Dechet dechet;
    private boolean visible;
    private float volume;
    private final int ID_PARC;
    
    public ControllersDepot(){
        // On ne passera jamais par ici
        this.recherche=null;
        this.result=null;
        this.visible=false;
        this.dechet=null;
        this.recherche=null;
        this.ListeDechet=null;
        this.listeDetails=null;
        this.ID_PARC= -1;
    }
    public ControllersDepot(URecyzone token){
        super(token);
        this.recherche=" ";
        this.result=new ArrayList();
        this.visible=false;
        this.dechet=null;
        this.recherche=null;
        this.ListeDechet=new ArrayList(DB_DECHET.values());
        this.listeDetails=new ArrayList();
        this.ID_PARC=token.getID_PARC();
    }
    public String getRecherche(){return recherche;}
    public void setRecherche(String recherche){this.recherche = recherche.trim();}
    public float getVolume(){return volume;}
    public void setVolume(float volume){this.volume = volume;}
    public ArrayList<Recherche> getResult() {
        /* Si pas de resultat on affiche pas les composants */
       this.visible=!this.result.isEmpty();
        return result;
    }
    public void setMenageSelected(ArrayList select){
        /* Si on encode des depot on peu pas changer */
        if(listeDetails.isEmpty()){
            if(select.size()>0)this.menageSelected=(Recherche) select.get(0);
        }
    }
    public ArrayList<Poubelles> getListeDepot() {return listeDetails;}
    public void setListeDepot(ArrayList<Poubelles> listeDepot) {this.listeDetails = listeDepot;}
    public Recherche getMenageSelected(){return this.menageSelected;}
    public ArrayList<Dechet> getBoxDechet(){return this.ListeDechet;}
    public void setResult(ArrayList<Recherche> result){this.result = result;}    
    public boolean getVisible(){return this.visible;}
    public Dechet getDechet(){return dechet;}
    public void setDechet(Dechet dechet){this.dechet = dechet;}
    public void faireRecherche() throws ParseException{
       try{
                if(!this.listeDetails.isEmpty() && this.menageSelected!=null)throw new DataException(ERROR_RECHERCHE);
                //NOTE: recherche indisponible si on a encoder des depots
                ArrayList<Recherche> search=new ArrayList();
                DBUtilisateur  request= new DBUtilisateur();
                ArrayList<Menage> resultUnFormat = request.searchMenage(this.token().getIdCommune(), this.recherche);
                resultUnFormat.stream().forEach((req) -> {search.add(new Recherche(req));});
                this.result = search;
                this.recherche = null;
                return;
       }catch(DataException err){this.afficherErreur(err);}
        //NOTE: utilisateur non trouve et liste vide
        if(this.listeDetails.isEmpty())this.result.clear();
        this.recherche = null;
    }
    public void depotAEnregistrer(){
        try{
                if(this.menageSelected == null) throw new DataException(ERROR_SELECT_MENAGE);
                if(!Validator.volumeEstValide(this.volume))throw new DataException(ERROR_NOMBRE);
                if(this.dechet == null) throw new DataException(ERROR_SELECT_DECHET);
                this.listeDetails.add(new Poubelles(this.dechet, this.volume, this.menageSelected.idMenage(), this.ID_PARC));
                this.ListeDechet.remove(this.dechet);
        }catch(DataException err){this.afficherErreur(err);}
        this.dechet=null;
        this.volume=0;    
    }
    public void deleteDepot(){
        try{
            if(this.listeDetails.isEmpty()) throw new DataException(ERROR_SELECT_DECHET);
            /* On copie dans une liste temporaire, on ne peut pas delete des element d une liste
                qu on est entraint de parcourir
            */
            ArrayList<Poubelles> listTemp=new ArrayList(this.listeDetails);
            /* Si le depot est a true on l efface de la liste et on remet le dechet dans la liste
                des dechets disponibles
            */
            this.listeDetails.stream().filter((delete) -> (delete.getSupprimer())).map((delete) -> {
                listTemp.remove(delete);
                return delete;
            }).forEach((delete) -> {this.ListeDechet.add((Dechet)delete);});
            this.listeDetails=listTemp;
        }catch(DataException err){this.afficherErreur(err);}
    }
    public float getMaximum(){
        if(this.listeDetails.isEmpty())return LIMIT_VOLUME;
        float sum=0.00f;
        sum = this.listeDetails.stream().map((token) -> token.getVolumeDepose()).reduce(sum, (accumulator, _item) -> accumulator + _item);
        return LIMIT_VOLUME-sum;
    }
    public void sauvegarderDepot(){
        try{
                if(this.listeDetails.isEmpty()) throw new DataException(ERROR_LIST_DEPOT);
                DBDepot request = new DBDepot();
                request.Depot(new Depot(this.menageSelected.idMenage(), this.listeDetails));
                /* Les depots on ete effectues on renitialise le tout */
               this.confirmation(DEPOT_OK);
        }catch(DataException err){this.afficherErreur(err);}
        this.dechet=null;
        this.menageSelected=null;
        this.listeDetails.clear();
        this.result.clear();
        this.ListeDechet=new ArrayList(DB_DECHET.values());
    }
    @Override
    public void disconnect(){NHPack.getInstance().closeWindow("views.Depot.xml");}
}
