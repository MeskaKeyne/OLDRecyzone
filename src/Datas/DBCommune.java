/**
 *          DBCommune
 *  Classe permettant de charger les Communes avec leur 
 *  localites depuis la BDD
 * 
 *  @author Somboom TUNSAJAN
 *  @since 01/05/2015
 *  @version 1.0
 */

package Datas;

import exceptions.DataException;
import static exceptions.Message.ERROR_COMMUNE_NOT_FOUND;
import java.util.ArrayList;
import java.util.HashMap;
import models.coordonnees.Commune;
import models.coordonnees.Localite;

public class DBCommune extends DBConnect{

    /**
     * Permet de charger la liste des communes avec leurs localite 
     * a partir de la BDD
     * @return une liste contenant les differentes communes
     */
    public HashMap<Commune, ArrayList<Localite>> readList(){
        try{
                HashMap<Commune, ArrayList<Localite>> listeCommune = new HashMap();
                String[][] result = this.bdd().createStatement(
                "SELECT c.IdCommune, c.Nom, p.codePostal, p.Localite FROM Commune c "
                + "INNER JOIN ParcConteneur p ON c.IdCommune = p.IdCommune "
                + "ORDER BY c.Nom, p.codePostal, p.Localite")
                .executeQuery();
                this.closeSession();
                if (result.length == 0) throw new DataException(ERROR_COMMUNE_NOT_FOUND);
                Commune current = new Commune(result[0]);
                ArrayList<Localite> listeLocalite= new ArrayList();
                listeLocalite.add(new Localite(Integer.parseInt(result[0][2]), result[0][3]));
                int i = 1;
                do{
                    if(result[i][0].compareTo(result[i - 1][0]) == 0) listeLocalite.add(new Localite(Integer.parseInt(result[i][2]), result[i][3]));
                    else{
                        listeCommune.put(current, listeLocalite); // Toutes les localités de la commune ont été récupérées
                        current = new Commune(result[i]);
                        listeLocalite = new ArrayList();
                        }
                    i++;
                } while (i < result.length);
        listeCommune.put(current, listeLocalite);
        return listeCommune;
       }catch(DataException err){this.traiterErreur(err);}
       return null;
    }
    public String[][] rechercheLocalite(int idCommune) {
        String[][] result = this.bdd().createStatement(" SELECT Localite, code_postal "
                                                       +" FROM localiteCommune "
                                                       +" WHERE @id = idCommune ")
                                                        .bindParameter("@id", idCommune)
                                                        .executeQuery();
        this.closeSession();
        if(result.length>0)return result;
        return null;

    }
}