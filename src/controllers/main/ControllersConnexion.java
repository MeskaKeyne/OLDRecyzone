/**
 * 
 *  ---> ASAP
 *          ControlllersConnexion
 *  Permet de se connecter a l'application via BDD
 *  et lance l instance correspondante
 * 
 *  @param id Contient son id
 *  @param login Contient son login
 *  @param role Contient le role occupe au sein de l application 
 * 
 *  @author Somboom TUNSAJAN
 *  @version 1.0
 */

package controllers.main;
import controllers.menage.ControllersMenage;
import Datas.DBUtilisateur;
import controllers.employe.ControllersEmploye;
import controllers.gerantInter.ControllersGerantInter;
import controllers.gerantParc.ControllersGerantParc;
import exceptions.DataException;
import static exceptions.Message.ERROR_AUTH;
import helmo.nhpack.NHPack;
import java.text.ParseException;
import models.utilisateurs.Menage;
import models.utilisateurs.Personne;
import models.utilisateurs.URecyzone;

public class ControllersConnexion extends ControllersMain { 
    private String user;
    private String password;
    private final String MESSAGE;
 
    public ControllersConnexion(){
        super();
        this.user = "";
        this.password = "";
        this.MESSAGE = "Encodez votre Login et mot de passe";
    }
    public String getUser(){return this.user;}
    public String getPassword(){return this.password.trim();}
    public String getMessage(){return this.MESSAGE;}
    public void setUser(String user){this.user= user;}
    public void setPassword(String password){this.password=password;}
    
    public void seConnecter() throws ParseException{
        try{
            DBUtilisateur request = new DBUtilisateur();
            Personne token =request.seConnecter(this.getUser(), this.getPassword());
            if(token == null) throw new DataException(ERROR_AUTH);
            if(token instanceof Menage)this.runWindowFor((Menage)token);
            else this.runWindowFor((URecyzone)token);
        }catch(DataException err){this.afficherErreur(err);}
        
    }
    private void runWindowFor(Menage token) {
        if(token == null) throw new NullPointerException("token is null"); // On passera jamais ici
        NHPack.getInstance().closeWindow("views.connexion.xml");
        ControllersMenage cm = new ControllersMenage((Menage) token);
        NHPack.getInstance().loadWindow("views.menage.xml", cm);
        NHPack.getInstance().showWindow("views.menage.xml");
    }
    private void runWindowFor(URecyzone token) throws ParseException{
        if(token == null) throw new NullPointerException("token is null"); // On passera jamais ici
        NHPack.getInstance().closeWindow("views.connexion.xml");
        switch(token.getID_ROLE()){
            case 3:  //Employe
                    NHPack.getInstance().loadWindow("views.Employe.xml", new ControllersEmploye(token)); 
                    NHPack.getInstance().showWindow("views.Employe.xml");
                break;
            case 2: //Gerant Parc
                  NHPack.getInstance().loadWindow("views.GerantParc.xml", new ControllersGerantParc(token)); 
                  NHPack.getInstance().showWindow("views.GerantParc.xml");
                break;
            case 1:
                NHPack.getInstance().loadWindow("views.GerantInter.xml", new ControllersGerantInter(token)); 
                NHPack.getInstance().showWindow("views.GerantInter.xml");
                break;
        }
    }

    @Override
    public void disconnect() {System.exit(0);}
  }
