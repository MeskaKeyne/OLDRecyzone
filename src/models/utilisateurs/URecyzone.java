/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.utilisateurs;

import exceptions.DataException;
import java.util.HashMap;

public class URecyzone extends Personne {
    final int ID_PARC;
    final int ID_ROLE;
    final int ID_COMMUNE;

    public URecyzone(HashMap data) throws DataException{
        super(data);
        this.ID_PARC=(int)data.get("idParc");
        this.ID_ROLE=(int)data.get("idRole");
        this.ID_COMMUNE= (int)data.get("idCommune");  
    }
    public int getID_ROLE(){return this.ID_ROLE;}
    public int getID_PARC(){return this.ID_PARC;}
    @Override public int getIdCommune(){return this.ID_COMMUNE;}
    
    
}
