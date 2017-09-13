/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Datas;
import java.util.HashMap;

/**
 *
 * @author Lz
 */
public interface IData  {
    static HashMap DB_COMMUNE = new DBCommune().readList();
    static HashMap DB_DECHET = new DBDepot().readList();
    static float LIMIT_VOLUME= 4.00f;
    
}
