
package models.utilisateurs;

import exceptions.DataException;
import static exceptions.Message.ERROR_EMAIL;
import static exceptions.Message.ERROR_ID;
import static exceptions.Message.ERROR_NOM;
import static exceptions.Message.ERROR_PRENOM;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import tools.Validator;

public abstract class Personne {
    
    private int id;
    private String nom;
    private String prenom;
    private String email;
  
   public Personne(){};
   public Personne(HashMap data){
       if(data == null) throw new NullPointerException("Personne() Hashmap is null");
       this.id=(int) data.get("id");
       this.nom=(String) data.get("nom");
       this.prenom=(String)data.get("prenom");
       this.email=(String)data.get("email");
        try {
            this.checkingPersonne();
        } catch (DataException ex){System.out.println(ex.getMessage());}
   }

   public int getId() {return id;}
   public final void checkingPersonne() throws DataException{
       if(this.id<0) throw new DataException(ERROR_ID);
       if(!Validator.stringEstValide(this.nom)) throw new DataException(ERROR_NOM);
       if(!Validator.stringEstValide(this.prenom)) throw new DataException(ERROR_PRENOM);
       if(!Validator.simpleMailEstValide(this.email)) throw new DataException(ERROR_EMAIL);
   }
    // --> implementation de toString apres
    
   @Override public String toString(){return String.format("<html><b> Nom </b>  %s    <b>Prenom</b> %s<br><b>Email: </b> %s", this.nom, this.prenom, this.email);}
   public String nomPrenom(){return this.nom.concat(" ").concat(this.prenom);}
   public String getNom(){return nom;}
   public String getPrenom(){return prenom;}
   public String getEmail(){return email;}
   public abstract int getIdCommune();
   
    public void faireInscription(){}
    
    
    public void encoderDepotDechet(){}
    
    public void afficherNotification(){}
    

}
