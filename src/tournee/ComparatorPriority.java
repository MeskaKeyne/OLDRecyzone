/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tournee;

import java.util.ArrayList;
import java.util.Comparator;

/**
 *
 * @author Lz
 */
public class ComparatorPriority implements Comparator<ArrayList<Camion>> {
    @Override public int compare(ArrayList<Camion> o1, ArrayList<Camion> o2) {return -Float.compare(o1.get(0).getPriority(), o2.get(0).getPriority());}  
}
