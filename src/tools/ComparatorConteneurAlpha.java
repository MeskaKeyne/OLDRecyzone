/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tools;

import java.util.Comparator;
import models.gestion.Conteneur;

/**
 *
 * @author Lz
 */
public class ComparatorConteneurAlpha implements Comparator<Conteneur>{

    @Override
    public int compare(Conteneur o1, Conteneur o2) {
        int value = o1.getNom().compareTo(o2.getNom());
        if(value < 0) return -1;
        if(value > 0) return 1;
        return -Float.compare(o1.getTauxRemplissage(), o2.getTauxRemplissage());
    }
    
}
