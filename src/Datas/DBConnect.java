package Datas;


import exceptions.DataException;
import helmo.nhpack.NHDatabaseSession;
import helmo.nhpack.db.ConnectionConfig;
import helmo.nhpack.db.SqlServerConnectionConfig;
import helmo.nhpack.exceptions.NHPackException;

/**
 *
 * @author Lz
 */
public abstract class DBConnect implements Configuration {
    final private ConnectionConfig DB;
    private NHDatabaseSession token;
    
    public DBConnect(){
            this.DB = new SqlServerConnectionConfig()
                    .withHost(HOST)
                    .withDatabase(DATABASE)
                    .withUserName(USER)
                    .withPassword(PASS);
        this.token = null;
    }
    protected NHDatabaseSession bdd(){
        if(this.token == null)this.token=this.open();
        return this.token;
    }
    private NHDatabaseSession open(){ 
        try{return new NHDatabaseSession(DB);}
        catch(NHPackException e){
            e.getMessage();
            return null;
        }
    }
    protected void closeTransaction(DataException ex){
       this.bdd().rollback();
       this.closeSession();
       this.traiterErreur(ex);
    }
    protected void closeTransaction(){
        this.bdd().commit();
        this.closeSession();  
    }
    protected void closeSession(){
        this.token.close();
        this.token=null;
    }
    protected void traiterErreur(DataException err){
        err.show();
        this.closeSession();
        System.exit(1); // Ce sont souvent des erreurs fatales
    }
}
