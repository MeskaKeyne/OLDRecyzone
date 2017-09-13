/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exceptions;

import helmo.nhpack.NHPack;

public enum Message {
    ERROR_CONNECT_BDD("Erreur lors de la connexion BDD"),
    ERROR_NOM("Le nom contient des erreurs"),
    ERROR_PRENOM("Le prenom contient des erreurs"),
    ERROR_EMAIL("Adresse mail incorrecte !"),
    ERROR_ID("ID incorrecte"),
    ERROR_RUE("Le nom de la rue contient des erreurs"),
    ERROR_CODE_POSTAL("Mauvais code postal"),
    ERROR_SELECT_LOCALITE("Pas de localite selectionée !"),
    ERROR_BOITE("Boite invalide"),
    ERROR_NUMERO("Numero invalide"),
    ERROR_LOCALITE("Mauvaise localite"),
    ERROR_ADULTE("Nombre d adulte incorrect !"),
    ERROR_ENFANT("Nombre d'enfants incorrect !"),
    ERROR_INSCRIPTION("Une erreur c'est produite lors de l'enregistrment"),
    ERROR_AUTH("Utilisateur non trouvé !"),
    ERROR_COMMUNE_NOT_FOUND("Erreur lors du chargement des communes"),
    ERROR_QUOTAS_ACTUEL("Erreur lors du chargement des quotas Actuel"),
    ERROR_NOMBRE("Nombre invalide"),
    ERROR_DECHET("Erreur lors du chargement des dechets"),
    ERROR_SELECT_DECHET("Pas de dechet selectionne"),
    ERROR_SELECT_MENAGE("Pas de menage selectionné"),
    ERROR_DECHET_NOT_FOUND("Ce dechet n'existe pas"),
    ERROR_RECHERCHE("recherche indisponible"),
    ERROR_VOLUME("Volume incorrect !"),
    ERROR_DEPOT_DATE("Vous avez deja effectué un depot aujourd'hui"),
    ERROR_LIST_DEPOT("Liste de depot vide"),
    ERROR_DEPOT("Le depot n'a pas été enregistré avec succes"),
    ERROR_DELETE_NOTIFICATION("Erreur lors de la supression des notifications"),
    ERROR_NOTIFICATION("Pas de notification(s) selectionné(s)"),
    ERROR_READ_CONTENEUR("Le parc n as pas de conteneur"),
    ERROR_READ_FACTURE("Probleme lors du chargement des factures"),
    ERROR_PAY_FACTURE("Echec du payement !"),
    ERROR_PAY_EVEN("Facture déja payé !"),
    ERROR_READ_TOURNE("Pas de conteneur selectionne pour la tournee"),
    ERROR_UPDATE_CONTENEUR("Une erreur c est produite lors du vidage des conteneurs !"),
    ERROR_READ_STATS("Une erreur est survenue lors du chargement des statistiques"),
    INSCRIPTION_OK("Inscription enregistrée !"),
    DEPOT_OK("Tout les depots ont été enregistré"),
    PAY_OK("Votre payement a été enregistré, Recyzone vous remercie"),
    NOTIFICATION_DELETE_OK("Toutes les notifications selectionées ont été supprimées");
    
    
    
    
       
    private final String STR;
    private Message(String message) {this.STR = message;}
    public String getMessage() {return this.STR;}
    @Override public String toString(){return this.STR;}
    public void showErreur(){NHPack.getInstance().showError("ERREUR", this.getMessage());}
    public void showMessage(){NHPack.getInstance().showInformation("INFOS", this.getMessage());}
    
}
