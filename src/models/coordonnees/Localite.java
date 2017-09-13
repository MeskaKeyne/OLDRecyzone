/**
 *      Localite
 *  Classe permettant de stocker une localite
 *  
 *  @param int CODE_POSTAL code postal de la localite   
 *  @param int NOM nom de la localite
 * 
 *  @author Somboom TUNSAJAN
 *  @since 01/05/15
 *  @version 1.0
 */
package models.coordonnees;

public final class Localite {
   final private int CODE_POSTAL;
   final private String NOM;
    
    public Localite(int codePostal, String nom){
        this.CODE_POSTAL = codePostal;
        this.NOM = nom;
    }
    public int getCodePostal(){return this.CODE_POSTAL;}
    public String getNom(){ return this.NOM;}
    @Override public String toString(){return "[ "+this.CODE_POSTAL+" ]" + " " + this.NOM;}
    
    
}
