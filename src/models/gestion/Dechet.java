/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.gestion;

import exceptions.DataException;
import static exceptions.Message.ERROR_ID;
import static exceptions.Message.ERROR_NOM;
import static exceptions.Message.ERROR_NOMBRE;
import java.util.HashMap;
import tools.Validator;

/**
 *
 * @author Lz
 */
public class Dechet {
    final private int ID;
    final private String NOM;
    final private float QA;
    
    public Dechet(HashMap data) throws DataException{
        this.ID=(int)data.get("id");
        this.NOM=(String)data.get("nom");
        this.QA=(float)data.get("quotaAnnuel");
        this.checkingDechet();
    }
    public Dechet(){
        this.ID =-1;
        this.NOM="Tous les Dechets";
        this.QA = -1;
    }
    public Dechet(Dechet d){
        this.ID = d.idDechet();
        this.NOM = d.getTypeDeDechet();
        this.QA=d.QA;
    }
    public String getTypeDeDechet(){return this.NOM;}
    public int idDechet(){return this.ID;}
    private void checkingDechet() throws DataException{
        if(!Validator.numeroEstValide(this.ID)) throw new DataException(ERROR_ID);
        if(!Validator.stringEstValide(this.NOM)) throw new DataException(ERROR_NOM);
        if(!Validator.floatEstValide(this.QA)) throw new DataException(ERROR_NOMBRE);
    }
    @Override public String toString(){return this.NOM;}
}
