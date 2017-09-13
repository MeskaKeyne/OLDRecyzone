package tournee;

import java.util.ArrayList;
import java.util.HashMap;
import models.gestion.Conteneur;

public class Tournee {
    public static ArrayList<Camion> generer(ArrayList<Conteneur> listeConteneur, int nbCamion){
        HashMap groupDechet = new HashMap();
        ArrayList<Camion> listeCamion;

        for (Conteneur cr : listeConteneur) {
            if (cr.getVider()) {
                if (!groupDechet.containsKey(cr.getNom())) {
                    listeCamion = new ArrayList();
                    listeCamion.add(new Camion(cr));
                    groupDechet.put(cr.getNom(), listeCamion);
                } else {
                    ArrayList<Camion> tmp = (ArrayList<Camion>) groupDechet.get(cr.getNom());
                    boolean flag = false;
                    int i = 0;
                    while (i < tmp.size() && flag == false) {
                        Camion cam = tmp.get(i);
                        if (cam.ajouterConteneur(cr)) flag = true;
                         else i++;      
                    }
                    if (flag == false) tmp.add(new Camion(cr));
                }
            }
        }
        ArrayList<ArrayList<Camion>> tourne = new ArrayList();
        tourne.addAll(groupDechet.values());
        tourne.sort(new ComparatorPriority());
        listeCamion = new ArrayList();
        int i = 0;
        for (ArrayList<Camion> myArray : tourne) {
            for(Camion cad: myArray){
                if(i< nbCamion)listeCamion.add(cad);
                i++;
            }
        }
        return listeCamion;
    }
}
