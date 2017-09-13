/**
 *      ControllersHeader
 *
 *  Cette classe permet d avoir un header sur la fenêtre associée
 * 
 *  @param HEAD_TXT contient le texte à afficher (nom prenon de l user)
 *  @param TODAY contient la date du jour sous la forme d un String
 * 
 *  @author Somboom TUNSAJAN
 *  @since 02/05/15
 *  @version 1.0
 */
package controllers.main;

import exceptions.DataException;
import exceptions.Message;
import helmo.nhpack.NHPack;
import java.util.Date;
import models.utilisateurs.Personne;
import tools.Validator;

public abstract class ControllersMain {
    final private String HEAD_TXT;
    final private String TODAY;
    final private Personne token;
    
    public ControllersMain(){
        this.TODAY = this.todayDate();
        this.HEAD_TXT="";
        this.token=null;
    }
    public ControllersMain(Personne token){
        this.TODAY=this.todayDate();
        this.token=token;
        this.HEAD_TXT=token.nomPrenom();
    }
    protected Personne token(){return this.token;}
    protected int getId(){return this.token.getId();}
    @Override public String toString(){return this.HEAD_TXT+" "+this.TODAY;}
    private String todayDate(){return Validator.dateToString(new Date());}
    public String getHeader(){return ""+this;}
    protected void reconnect(){
        NHPack.getInstance().loadWindow("views.connexion.xml", new ControllersConnexion());
        NHPack.getInstance().showWindow("views.connexion.xml");
    }
    final public void afficherErreur(DataException err){err.show();}
    final public void confirmation(Message confirmation){confirmation.showMessage();}
    abstract public void disconnect();
    
}
