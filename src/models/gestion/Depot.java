/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.gestion;

import java.util.ArrayList;

/**
 *
 * @author Lz
 */
public class Depot {
    
    private final int ID_MENAGE;
    private final ArrayList<Poubelles> DETAILS;
    
    public Depot(int idMenage, ArrayList<Poubelles> details){
        this.ID_MENAGE = idMenage;
        this.DETAILS = details;
    }

    public int getID_MENAGE() {
        return ID_MENAGE;
    }

    public ArrayList<Poubelles> getDETAILS() {
        return DETAILS;
    }
    
}
