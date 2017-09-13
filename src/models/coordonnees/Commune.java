/**
 *              Commune
 *  Classe permettant de stocker les données d'une commune
 * 
 *  @param ID id de la commune
 *  @param NOM nom de la commune
 *  @param listeLocalte les des localités faisant partie de la commune
 * 
 *  @author Somboom TUNSAJN
 *  @since 01/05/15
 *  @version 1.0
 */
package models.coordonnees;

public final class Commune {
    final private int ID;
    final private String NOM;
    public Commune(String[] data){
        this.ID =Integer.parseInt(data[0]);
        this.NOM = data[1];
    }
    public int getId(){return this.ID;}
    public String getNom(){return this.NOM;}
    @Override public String toString(){
        String out;
        out = this.NOM;
        return out;
    }
}
