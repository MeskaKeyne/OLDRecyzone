
package models.coordonnees;

import exceptions.DataException;
import static exceptions.Message.ERROR_BOITE;
import static exceptions.Message.ERROR_LOCALITE;
import static exceptions.Message.ERROR_NUMERO;
import static exceptions.Message.ERROR_RUE;
import java.util.HashMap;
import tools.Validator;

public class Adresse {
    final private String RUE;
    final private int NUMERO;
    final private String LOCALITE;
    final private int CODE_POSTAL;
    final private String BOITE;
    final private int ID_COMMUNE;
    
    public Adresse(HashMap data) throws DataException{
        if(data == null) throw new NullPointerException("Adresse() is null");
        this.RUE=(String)data.get("rue");
        this.NUMERO=(int)data.get("numero");
        this.BOITE=(String) data.get("boite");
        this.LOCALITE=(String)data.get("localite");
        this.CODE_POSTAL=(int)data.get("codePostal");
        this.ID_COMMUNE=(int)data.get("idCommune");
        this.checkingAdresse();
        
    }
    private void checkingAdresse() throws DataException{
        if(!Validator.localiteEstValide(this.LOCALITE, this.ID_COMMUNE, this.CODE_POSTAL)) throw new DataException(ERROR_LOCALITE);
        if(!Validator.BoiteEstValide(this.BOITE)) throw new DataException(ERROR_BOITE);
        if(!Validator.numeroEstValide(this.NUMERO)) throw new DataException(ERROR_NUMERO);
        if(!Validator.stringEstValide(this.RUE)) throw new DataException(ERROR_RUE);
    }

    public String getRUE(){return this.RUE;}
    public int getNUMERO(){return this.NUMERO;}
    public String getLOCALITE(){return this.LOCALITE;}
    public int getCODE_POSTAL(){return this.CODE_POSTAL;}
    public String getBOITE(){return this.BOITE;}
    public int getID_COMMUNE(){return this.ID_COMMUNE;}
    
    @Override
    public String toString(){
        String out="";
        out+=this.NUMERO+" "+this.BOITE+" "+this.RUE+"<br>";
        out+=this.CODE_POSTAL+" "+this.LOCALITE;
        return out;
    }
}
