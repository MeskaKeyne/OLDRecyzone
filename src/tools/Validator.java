/**
 *      Validator (static)
 *  Permet de valider des données
 * 
 *  @author TUNSAJAN Somboom & RUSHOP Hugo
 *  @version 1.1
 *  @since 11/05/15
 */
package tools;

import Datas.DBCommune;
import Datas.DBUtilisateur;
import Datas.IData;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.gestion.Dechet;


public class Validator implements IData {
    public static boolean emailEstValide(String email) {
        DBUtilisateur  request = new DBUtilisateur();
        return (simpleMailEstValide(email) && !request.checkEmail(email));
    }
    public static boolean simpleMailEstValide(String email){
        if(email.indexOf('@')>0){
            email=email.substring(email.indexOf('@'), email.length());
            return (email.indexOf('.') > 1);
        }
        return false;
    }
    public static boolean numeroEstValide(int numero){return numero >0;}
    public static boolean BoiteEstValide(String boite){
        if(" ".equals(boite) )return true;
        else return boite.matches("[a-zA-Z]+");
    }
    public static boolean stringEstValide(String str){return str != null && str.length() >=2;}
    public static boolean localiteEstValide(String localite, int idCommune, int codePostal){
        DBCommune request = new DBCommune();
        String[][] result = request.rechercheLocalite(idCommune); ///A revoir
        if(result == null) return false;
        for(int i = 0 ; i < result.length;i++){
            if (localite.equalsIgnoreCase(result[i][0])){
                if(Integer.parseInt(result[i][1]) == codePostal) return true;
            }     
       }
       return false;
    }
    public static boolean floatEstValide(float f){return f>=0;}
    public static boolean volumeEstValide(float v){return v>0;}
    public static boolean dechetEstValide(Dechet value){return DB_DECHET.containsValue(value);}
    public static Date stringToDate(String myDate){
        try {
            return new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse(myDate);
        } catch (ParseException ex) {Logger.getLogger(Validator.class.getName()).log(Level.SEVERE, null, ex);}
        return null;
    }
    public static String dateToString(Date myDate){return new SimpleDateFormat("dd MMM yyyy à HH:mm").format(myDate);}
        
    
    
}
