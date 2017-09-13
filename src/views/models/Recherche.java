/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package views.models;

import models.utilisateurs.Menage;

/**
 *
 * @author Lz
 */
public class Recherche {
    private int id;
    private String NomPrenom;
    private String adresse;
    private String email;
    
    public Recherche(Menage token){
        if(token == null) throw new NullPointerException("token is null");
        this.NomPrenom=token.nomPrenom();
        this.adresse=String.format(token.getNumero()+token.getBoite()+" "+token.getRue()+" "+token.getLocalite()+" "+token.getCodePostal());
        this.email=token.getEmail();
        this.id=token.getId();
    }
    @Override public String toString(){return this.NomPrenom+" "+this.adresse+" "+this.email;}
    public String getNomPrenom(){return NomPrenom;}
    public String getAdresse(){return adresse;}
    public String getEmail(){return email;}
    public int idMenage(){return this.id;}
    
    
    
}
