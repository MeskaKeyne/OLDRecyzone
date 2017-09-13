/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;

import exceptions.DataException;
import static exceptions.Message.ERROR_QUOTAS_ACTUEL;
import java.util.ArrayList;
import java.util.HashMap;
import views.models.QuotasActuel;

/**
 *
 * @author Lz
 */
public class DBQuota extends DBConnect {

    public ArrayList<QuotasActuel> read(int id){
        try {
            String result[][] = this.bdd().createStatement("SELECT nom, volume_utilise, volume_autorise, volume_restant "
                    + " FROM quota"
                    + " WHERE idMenage=@id")
                    .bindParameter("@id", id)
                    .executeQuery();
            this.closeSession();
            if (result.length == 0) throw new DataException(ERROR_QUOTAS_ACTUEL);
            ArrayList<QuotasActuel> list = new ArrayList();
            for (String req[] : result) list.add(new QuotasActuel(formatQuery(req)));
            return list;
        } catch (DataException err){this.traiterErreur(err);}
        return null;
    }
    public float calculateQuotaUsed(int id, int idDechet, float volume) {
        try {
                    String result[][] = this.bdd().createStatement("DECLARE @RESULT DECIMAL(18,2) "
                    + "EXEC calculPourcentage @idMenage, @volume, @idDechet")
                    .bindParameter("@idMenage", id)
                    .bindParameter("@idDechet", idDechet)
                    .bindParameter("@volume", volume)
                    .executeQuery();
            this.closeSession();
            if (result.length == 0) throw new DataException(ERROR_QUOTAS_ACTUEL);
            return Float.parseFloat(result[0][0]);
        } catch (DataException err) {this.traiterErreur(err);}
        return Float.NaN;
    }
    private HashMap formatQuery(String[] req){
        if (req == null) throw new NullPointerException("req is null");
        HashMap quota = new HashMap();
        quota.put("typeDechet", req[0]);
        quota.put("volumeDepose", Float.parseFloat(req[1]));
        quota.put("volumeAuthorized", Float.parseFloat(req[2]));
        quota.put("reste", Float.parseFloat(req[3]));
        return quota;
    }
}
