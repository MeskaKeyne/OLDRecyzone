/**
 *      DBConnexion
 * 
 *  Permet d aller chercher l utilisateur qui se connecte 
 *  dans la BDD
 * 
 * @author TUNSAJAN Somboom 
 * @version v1.0
 * @since 29/04/15
 */
package Datas;


import exceptions.DataException;
import static exceptions.Message.ERROR_AUTH;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import models.utilisateurs.Personne;
import models.utilisateurs.Menage;
import models.utilisateurs.URecyzone;
import tools.Validator;


public class DBUtilisateur extends DBConnect {

   public DBUtilisateur(){super();}
    /**
     *  Permet de se connecter à Recyzone
     * @param user de l application
     * @param password de l useer
     * @return les information de l utilisateur
     * @throws exceptions.DataException
     * @throws java.text.ParseException
     */
    public Personne seConnecter(String user, String password) throws DataException, ParseException{
          String[][] result = this.bdd().createStatement("SELECT id, role, login "
          +" FROM v_auth"
          +" WHERE login LIKE @user "
          +" AND CONVERT(VARCHAR(100),HASHBYTES('SHA1',@password),1) LIKE password ")
          .bindParameter("@user", user)
          .bindParameter("@password", password)
          .executeQuery();
          this.closeSession();
        if(result.length!=0) return this.readUser(result[0]);
        return null; // Pas de resultat trouve
    }
    
    /**
     *  Charge un utilisateur en fonction des infos fournies
     * @param infos de l user pour lequel on veut des informations
     * @return les infos de la personne
     * @throws exceptions.DataException
     */
    private Personne readUser(String infos[]) throws DataException, ParseException{
        if(infos == null) throw new NullPointerException("infos is null");
        if(Integer.parseInt(infos[1]) > 0){
            String result[][] = this.bdd().createStatement("SELECT u.IdUtilisateur, u.Nom, u.Prenom, u.Email, u.IdParcConteneur, u.idrole, pc.IdCommune "
            +" FROM utilisateur u "
            +" LEFT JOIN ParcConteneur pc on pc.IdParcConteneur = u.IdParcConteneur "
            + "WHERE @id = idUtilisateur")
            .bindParameter("@id", infos[0])
            .executeQuery();
            this.closeSession();
            return new URecyzone(this.formatQuery(result[0]));
        }
        String result[][] = this.bdd().createStatement("SELECT * "
        + "FROM MENAGE "
        + "WHERE @id = idMenage")
        .bindParameter("@id", infos[0])
        .executeQuery();
        this.closeSession();
        System.out.println("--- MENAGE ---");
        return new Menage(this.formatQuery(result[0]));
       
    }
    public int insertMenage(Menage save){
        if(save == null) throw new NullPointerException("save is null");
        int result = this.bdd().createStatement("INSERT INTO MENAGE (NomContact, PrenomContact, EmailContact, Rue, Numero, Boite, CodePostal, Localite, NbreAdultes, NbreEnfants ,IdCommune) " 
               +" VALUES (@nomContact, @prenomContact, @emailContact, @rue, @numero, @boite, @codePostal, @localite, @nbAdultes, @nbEnfants, @idCommune)")
               .bindParameter("@nomContact", save.getNom())
               .bindParameter("@prenomContact", save.getPrenom())
               .bindParameter("@emailContact", save.getEmail())
               .bindParameter("@rue", save.getRue())
               .bindParameter("@numero", save.getNumero())
               .bindParameter("@boite", save.getBoite())
               .bindParameter("@codePostal", save.getCodePostal())
               .bindParameter("@localite", save.getLocalite())
               .bindParameter("@nbAdultes", save.getNbAdultes())
               .bindParameter("@nbEnfants", save.getNbEnfants())
               .bindParameter("@idCommune", save.getIdCommune())
               .executeUpdate();
        return result;   
    }
    public boolean checkEmail(String email) {
        if(email == null) throw new NullPointerException("email is null");
        String[][] result = this.bdd().createStatement(
                "SELECT EmailContact FROM Menage WHERE emailContact = @email ")
                .bindParameter("@email", email)
                .executeQuery();
        this.closeSession();
        return result.length != 0;
    }
    public ArrayList<Menage> searchMenage(int idCommune, String search) throws DataException, ParseException{
        if(search == null||"".equals(search)) throw new DataException(ERROR_AUTH);
        String[][] result = this.bdd().createStatement("SELECT * "
        +" FROM menage " 
        +" WHERE idCommune = @idCommune AND NomContact LIKE CONCAT('%',@search,'%');")
        .bindParameter("@search", search)
        .bindParameter("@idCommune", idCommune)
        .executeQuery();
        if(result.length <= 0) throw new DataException(ERROR_AUTH);
        ArrayList<Menage> list=new ArrayList();
        for(String req[] : result)list.add(new Menage(formatQuery(req)));
        return list;
        
    }
    public String readLastVisite(int id){
        
        String[][] result = this.bdd().createStatement("SELECT Max(d.date)"
                + " FROM DEPOT"
                + " d WHERE d.idmenage = @id")
                .bindParameter("@id", id)
                .executeQuery();
        if(result[0][0] == null) return "Pas encore de visite";
        return Validator.dateToString(Validator.stringToDate(result[0][0]));       
    }

    private HashMap formatQuery(String[] req){
        if(req == null) throw new NullPointerException("req is null");
        HashMap data=new HashMap();
        data.put("id", Integer.parseInt(req[0]));
        data.put("nom", req[1]);
        data.put("prenom", req[2]);
        data.put("email", req[3]);
        if(req.length == 7){
            if(req[4] == null) data.put("idParc", 0);
            else data.put("idParc", Integer.parseInt(req[4]));
            data.put("idRole", Integer.parseInt(req[5]));
            if(req[6] == null)data.put("idCommune", 0);
            else data.put("idCommune", Integer.parseInt(req[6]));
            return data;
        }
        data.put("rue", req[4]);
        data.put("numero", Integer.parseInt(req[5]));
        if(req[6] == null)req[6] =String.format(" ");
        data.put("boite", req[6]);
        data.put("codePostal", Integer.parseInt(req[7]));
        data.put("localite", req[8]);
        data.put("nbEnfants", Integer.parseInt(req[10]));
        data.put("nbAdultes", Integer.parseInt(req[9]));
        data.put("idCommune", Integer.parseInt(req[13]));
        return data;
    }
}
