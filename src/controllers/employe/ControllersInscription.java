/**
 * 
 *      ControllersInscription
 *  
 *  Permet d'inscrire un menage en BDD
 * 
 *  @param Hashmap VALUES contient les valeurs pour inscrire le 
 *                        membre
 *  @param Commune selectedCommune Contient la commune selectionée
 *  @param Localite selectedLocalite Contient la localite selectionée
 *  @param ArrayList<Commune> AL_COMMUNE contient la liste des communes
 *  @param ArrayList<Localite> listeLocalite Contient la liste des localite
 * 
 *  @author TUNSAJAN Somboom
 *  @since 10/05/15
 *  @version 1.1b
 */
package controllers.employe;

import Datas.IData;
import Datas.DBUtilisateur;
import controllers.main.ControllersMain;
import exceptions.DataException;
import static exceptions.Message.ERROR_BOITE;
import java.util.ArrayList;
import java.util.HashMap;
import static exceptions.Message.ERROR_EMAIL;
import static exceptions.Message.ERROR_INSCRIPTION;
import static exceptions.Message.ERROR_NOM;
import static exceptions.Message.ERROR_NUMERO;
import static exceptions.Message.ERROR_PRENOM;
import static exceptions.Message.ERROR_RUE;
import static exceptions.Message.ERROR_SELECT_LOCALITE;
import static exceptions.Message.INSCRIPTION_OK;
import helmo.nhpack.NHPack;
import java.text.ParseException;
import models.coordonnees.Commune;
import models.coordonnees.Localite;
import models.utilisateurs.Menage;
import models.utilisateurs.URecyzone;
import tools.Validator;

public class ControllersInscription extends ControllersMain implements IData {

    private final HashMap VALUES;
    private Commune selectedCommune;
    private Localite selectedLocalite;
    private final ArrayList<Commune> AL_COMMUNE;
    private ArrayList<Localite> listeLocalite;

    public ControllersInscription(){
        this.AL_COMMUNE = new ArrayList<>(DB_COMMUNE.keySet());
        this.listeLocalite = new ArrayList();
        this.selectedCommune = this.AL_COMMUNE.get(0);
        this.listeLocalite = (ArrayList<Localite>) DB_COMMUNE.get(this.AL_COMMUNE.get(0));
        this.selectedLocalite = this.listeLocalite.get(0);
        /* On initialise les champs */
        this.VALUES = new HashMap();
        this.VALUES.put("id", 0);
        this.VALUES.put("nom", "");
        this.VALUES.put("prenom", "");
        this.VALUES.put("email", "");
        this.VALUES.put("rue", "");
        this.VALUES.put("numero", 0);
        this.VALUES.put("codePostal", 0);
        this.VALUES.put("boite", "");
        this.VALUES.put("localite", this.selectedLocalite.getNom());
        this.VALUES.put("idCommune", 1);
        this.VALUES.put("nbEnfants", 0);
        this.VALUES.put("nbAdultes", 1);
    }
    public ControllersInscription(URecyzone token) {
        super(token);
        /* On construit la liste des communes a partir de la Hashmap */
        this.AL_COMMUNE = new ArrayList<>(DB_COMMUNE.keySet());
        //this.listeLocalite = new ArrayList();
        this.selectedCommune = this.AL_COMMUNE.get(0);
        this.listeLocalite = (ArrayList<Localite>) DB_COMMUNE.get(this.AL_COMMUNE.get(0));
        this.selectedLocalite = this.listeLocalite.get(0);
        /* On initialise les champs */
        this.VALUES = new HashMap();
        this.VALUES.put("id", 0);
        this.VALUES.put("nom", "");
        this.VALUES.put("prenom", "");
        this.VALUES.put("email", "");
        this.VALUES.put("rue", "");
        this.VALUES.put("numero", 0);
        this.VALUES.put("codePostal", 0);
        this.VALUES.put("boite", " ");
        this.VALUES.put("localite", this.selectedLocalite.getNom());
        this.VALUES.put("idCommune", 1);
        this.VALUES.put("nbEnfants", 0);
        this.VALUES.put("nbAdultes", 1);
    }
    public String getNom() {return (String) this.VALUES.get("nom");}
    public void setNom(String nom){this.VALUES.replace("nom", nom.toUpperCase());}
    public String getPrenom(){return (String) this.VALUES.get("prenom");}
    public void setPrenom(String prenom){this.VALUES.replace("prenom", prenom);}
    public String getMail(){return (String) this.VALUES.get("email");}
    public void setMail(String mail) {this.VALUES.replace("email", mail);}
    public String getRue(){return (String) this.VALUES.get("rue");}
    public void setRue(String rue){this.VALUES.replace("rue", rue);}
    public String getBoite(){return (String)this.VALUES.get("boite");}
    public void setBoite(String boite){
        if(boite == null) boite=" ";
        this.VALUES.replace("boite", boite);
    }
    public int getNumero(){return (int) this.VALUES.get("numero");}
    public void setNumero(int numero){this.VALUES.replace("numero", numero);}
    public ArrayList<Commune> getListeCommune(){return this.AL_COMMUNE;}
    public Commune getCommune(){return this.selectedCommune;}
    public void setCommune(Commune selectedValue) {
        this.selectedCommune = selectedValue;
        this.VALUES.replace("idCommune", this.selectedCommune.getId());
    }
    public ArrayList<Localite> getListeLocalite(){return this.listeLocalite;}
    public Localite getLocalite(){return this.selectedLocalite;}
    public void setLocalite(Localite selectedValue) {
        this.selectedLocalite = selectedValue;
        this.VALUES.replace("localite", this.selectedLocalite.getNom());
        this.VALUES.replace("codePostal", this.selectedLocalite.getCodePostal());
    }
    public int getNbEnfants(){return (int) this.VALUES.get("nbEnfants");}
    public void setNbEnfants(int nb){this.VALUES.replace("nbEnfants", nb);}
    public int getNbAdultes(){return (int) this.VALUES.get("nbAdultes");}
    public void setNbAdultes(int nb){this.VALUES.replace("nbAdultes", nb);}
    public void changedLocalite(){this.listeLocalite = (ArrayList<Localite>) DB_COMMUNE.get(this.selectedCommune);}

    public void saveInscription() throws ParseException{
        try {
            if (checkingField()) {
                DBUtilisateur request = new DBUtilisateur();
                if(request.insertMenage(new Menage(this.VALUES))==1) INSCRIPTION_OK.showMessage();
                else throw new DataException(ERROR_INSCRIPTION);
                NHPack.getInstance().closeWindow("views.InscriptionMenage.xml");
            }
        } catch (DataException erreur){this.afficherErreur(erreur);}
    }
    private boolean checkingField() throws DataException{
      if(!Validator.stringEstValide((String)this.VALUES.get("nom")))throw new DataException(ERROR_NOM);
      if(!Validator.stringEstValide((String)this.VALUES.get("prenom")))throw new DataException(ERROR_PRENOM);
      if(!Validator.emailEstValide((String)this.VALUES.get("email")))throw new DataException(ERROR_EMAIL);
      if(!Validator.stringEstValide((String)this.VALUES.get("rue")))throw new DataException(ERROR_RUE);
      if((int)this.VALUES.get("codePostal") == 0)throw new DataException(ERROR_SELECT_LOCALITE);
      /*if(this.VALUES.get("boite") != " "){
          if(!Validator.BoiteEstValide((String)this.VALUES.get("boite"))) throw new DataException(ERROR_BOITE);
      }*/
      if(!Validator.numeroEstValide((int) this.VALUES.get("numero"))) throw new DataException(ERROR_NUMERO);
      return true;
    }
    @Override public void disconnect() {NHPack.getInstance().closeWindow("views.InscriptionMenage.xml");}
}
