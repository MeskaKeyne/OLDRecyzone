/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models.gestion;

import Datas.DBQuota;
import exceptions.DataException;
import static exceptions.Message.ERROR_ID;
import static exceptions.Message.ERROR_VOLUME;
import tools.Validator;

/**
 *
 * @author Lz
 */
public class Poubelles extends Dechet {
    private final float VOLUME;
    private final float QUOTA_USED;
    private final int ID_PARC;
    private boolean etat;
   
    
    public Poubelles(Dechet type, float volume, int idMenage, int idParc) throws DataException{
        super(type);
        this.VOLUME = volume;
        this.ID_PARC=idParc;
        this.checkingDepot();
        this.QUOTA_USED= new DBQuota().calculateQuotaUsed(idMenage, this.idDechet(), this.VOLUME);
        this.etat=false;
    }
    private void checkingDepot() throws DataException{
        if(!Validator.volumeEstValide(this.VOLUME)) throw new DataException(ERROR_VOLUME);
        if(!Validator.numeroEstValide(this.ID_PARC)) throw new DataException(ERROR_ID);
    }
    public int idParc(){return this.ID_PARC;}
    public float getVolumeDepose(){return VOLUME;}
    public float getQuotaUtilise() {return QUOTA_USED;}
    public boolean getSupprimer(){return this.etat;}
    public void setSupprimer(boolean etat){this.etat=etat;}
    
}
