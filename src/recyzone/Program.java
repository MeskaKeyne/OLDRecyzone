/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package recyzone;

import controllers.main.ControllersConnexion;
import helmo.nhpack.NHPack;


public class Program {

    public static void main(String[] args){

        NHPack.getInstance().loadWindow("views.connexion.xml", new ControllersConnexion());
        NHPack.getInstance().showWindow("views.connexion.xml");
    }
}
