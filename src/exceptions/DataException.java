/**
 *      DataException
 *  Bloc d exception pour les datas
 * 
 *  @param Message EX Structure (enum) contenant l erreur à traiter
 * 
 *  @author Somboom TUNSAJAN
 *  @since 10/05/15
 *  @version 1.0
 */
package exceptions;

import helmo.nhpack.NHPack;

public class DataException extends Exception{
    private final Message EX;
    public DataException(Message err){
        super(err.getMessage());
        this.EX=err;
    }
    public DataException(String err){
        super(err);
        this.EX = null;
    }
    public void show(){
        if(this.EX!=null)NHPack.getInstance().showError("ERROR", ""+this.EX);
        else NHPack.getInstance().showError("ERROR", ""+this.getMessage());
    }
}
