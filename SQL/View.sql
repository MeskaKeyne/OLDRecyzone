/****** Object:  View [dbo].[dechetByMenage]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[dechetByMenage] (idMenage, idCoefficient, idDechet, nom)
/*Fait le lien entre ménage et déchet*/
AS
SELECT m.idMenage, m.idCoefficient, td.IdTypeDechet, td.nom
FROM typeDechet td, Menage m

GO
/****** Object:  View [dbo].[quota]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[quota] (idMenage, idTypeDechet, nom, volume_autorise, volume_utilise, volume_restant, quota_Annuel)
AS

/*Calcul : 
1) volumeAutorise = VolumeDeBase*CoefficientDuMenage 
2) VolumeUtilise = VolumeDejaDepose
3) VolumeRestant = quotaAnnuel*coefficient - volumeUtilise
4) quotaAnnuel = Somme(VolumeDeBase)/LimiteNonCorrige*coefficient
*/

SELECT dbm.idmenage, iddechet, nom, --select simple
	--Calcul du quota de base corrigé

	--Sous-requête qui va chercher le volume de base autorisé dans la table typeDeDechet
	(SELECT coalesce(quotaannuel,0)
	FROM typedechet 
	WHERE iddechet = idtypedechet)*--Multiplication par le coefficient en fonction du ménage
									(SELECT co.coefficient 
									FROM coefficient co 
									JOIN menage m ON m.idcoefficient = co.idcoefficient 
									WHERE m.idmenage = dbm.idmenage) , 
		--Calcule du volume déjà déposé
		(SELECT coalesce(SUM(c.volume),0.0) 
		FROM concerner c 
		JOIN depot d ON d.iddepot = c.iddepot
		WHERE iddechet = c.idtypedechet and d.idmenage = dbm.idmenage
		and d.date  > coalesce((Select Max(dateFacturation) from dernierefacturation),0)),
		--selection du quota annuel
			(SELECT coalesce(quotaannuel,0.0)
			FROM typedechet 
			WHERE iddechet = idtypedechet)*(SELECT co.coefficient 
											FROM coefficient co 
											JOIN menage m ON m.idcoefficient = co.idcoefficient 
											WHERE m.idmenage = dbm.idmenage)- 
				(SELECT coalesce(SUM(c.volume),0.0) 
				FROM concerner c 
				JOIN depot d ON d.iddepot = c.iddepot
				WHERE iddechet = c.idtypedechet and d.idmenage = dbm.idmenage
				and  d.date  > coalesce((Select Max(dateFacturation) from dernierefacturation),0)),
			coalesce (CAST(ROUND((SELECT coalesce(SUM(c.volume),0.0) 
						FROM concerner c 
						JOIN depot d ON d.iddepot = c.iddepot
						JOIN menage m ON m.idmenage =d.idmenage
						WHERE iddechet = c.idtypedechet and m.idmenage = dbm.idmenage
						and d.date  > coalesce ((Select Max(dateFacturation) from dernierefacturation),0))/(SELECT quotaannuel
																						FROM typedechet 
																						WHERE iddechet = idtypedechet)*(SELECT co.coefficient 
																														FROM coefficient co 
																													JOIN menage m ON m.idcoefficient = co.idcoefficient 
																														WHERE m.idmenage = dbm.idmenage)*100,2,0)as decimal(18,2)),0)


FROM dechetBymenage dbm
GO
/****** Object:  View [dbo].[detailFacturation]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[detailFacturation] (idMenage, idTypeDechet, MontantForfait, prixVariable, exedant)
AS

SELECT q.idmenage, q.idtypedechet, 

--Sélectionne l'idForfait en fonction du typeDedechet et de l'id surplus
(select montantForfait from forfait f where f.idtypedechet = q.idtypedechet aND idsurplus = 
(select idsurplus from surplus where q.volume_restant < 0 and abs(q.volume_restant) between pourcentagemin and pourcentagemax)) as idforfait,

--Calcul le prix vaible en fonction du forfait, du type de dechet et de l'id du surplus
CAST((SELECT (abs(q.volume_restant)/0.25)*f.variable from forfait f where f.idtypedechet = q.idtypedechet aND idsurplus = 
(select idsurplus from surplus where q.volume_restant < 0 and abs(q.volume_restant) between pourcentagemin and pourcentagemax))as numeric (4,2)), 

--VolumeRestant
abs(q.volume_restant) 
from quota q
where q.volume_restant < 0

GO
/****** Object:  View [dbo].[detailConteneur]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[detailConteneur] (idConteneur, adresse, emplacement, tauxRemplissage, volume, idParcConteneur, idTypeDechet, vUsed ) AS 
SELECT c.idConteneur,  p.Rue + ' ' + p.Numero + ' - ' + CAST(p.CodePostal AS VARCHAR(4)) + ' ' + p.Localite,
c.numEmplacement ,  CAST(c.volumeUtilise/c.capacite*100 AS numeric(4,1)), c.capacite, p.idParcConteneur, t.idTypeDechet, c.volumeUtilise
FROM Conteneur c
JOIN TypeDechet t ON t.idTypeDechet = c.idTypeDechet
JOIN ParcConteneur p ON p.idParcConteneur = c.idParcConteneur

GO
/****** Object:  View [dbo].[localiteCommune]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[localiteCommune] (idCommune, Commune, code_postal, localite)
AS
SELECT c.IdCommune, c.Nom, p.codePostal, p.Localite FROM Commune c 
        INNER JOIN ParcConteneur p ON c.IdCommune = p.IdCommune 
    
GO
/****** Object:  View [dbo].[statistiqueVisiteJourInter]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[statistiqueVisiteJourInter] ( moyenneVisite, jour, idjour)
AS

--SELECT par un idParc ( qui peut être null, et par jour) / nombreDeJour
--Union de tous

SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(null, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7


GO
/****** Object:  View [dbo].[statistiqueVisiteJourParc]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVisiteJourParc] ( moyenneVisite, jour, idJour, idParcConteneur)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcJour(c.idparcconteneur, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[statistiqueVisiteMoisInter]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVisiteMoisInter] ( moyenneVisite, mois, idMois)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcmois(null, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12
GO
/****** Object:  View [dbo].[statistiqueVisiteMoisParc]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVisiteMoisParc] ( moyenneVisite, mois, idMois, idParcConteneur)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.visiteParParcMois(c.idparcconteneur, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[statistiqueVolumeJourInter]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeJourInter] ( moyenneVolume, jour, idJour)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(null, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7
GO
/****** Object:  View [dbo].[statistiqueVolumeJourInterDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeJourInterDechet] ( moyenneVolume, jour, idJour, idDechet)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,1, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,2, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,3, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,4, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,5, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,6, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null,7, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', null),0)as numeric(8,2)),0)), 'lundi',1, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', null),0)as numeric(8,2)),0)), 'mardi',2, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', null),0)as numeric(8,2)),0)), 'mercredi',3, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', null),0)as numeric(8,2)),0)), 'jeudi',4, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', null),0)as numeric(8,2)),0)), 'vendredi',5, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', null),0)as numeric(8,2)),0)), 'samedi',6, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 1, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 2, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 3, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 4, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 5, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 6, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(null, 7, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', null),0)as numeric(8,2)),0)), 'dimanche',7, 7
GO
/****** Object:  View [dbo].[statistiqueVolumeJourParc]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeJourParc] ( moyenneVolume, jour, idJour, idParcConteneur)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJour(c.idparcconteneur, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[statistiqueVolumeJourParcDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeJourParcDechet] ( moyenneVolume, jour, idJour, idParcConteneur, idDechet)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'lundi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('lundi', c.idparcconteneur),0)as numeric(8,2)),0)), 'lundi',1, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'mardi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mardi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mardi',2, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'mercredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('mercredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'mercredi',3, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'jeudi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('jeudi', c.idparcconteneur),0)as numeric(8,2)),0)), 'jeudi',4, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'vendredi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('vendredi', c.idparcconteneur),0)as numeric(8,2)),0)), 'vendredi',5, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'samedi') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('samedi', c.idparcconteneur),0)as numeric(8,2)),0)), 'samedi',6, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,1, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,2, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,3, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,4, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,5, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,6, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcJourDechet(c.idparcconteneur,7, 'dimanche') as numeric(8,2))
/NULLIF(dbo.diviseurjour ('dimanche', c.idparcconteneur),0)as numeric(8,2)),0)), 'dimanche',7, c.idparcconteneur,7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[statistiqueVolumeMoisInter]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeMoisInter] ( moyenneVolume, mois, idMois)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmois(null, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12
GO
/****** Object:  View [dbo].[statistiqueVolumeMoisInterDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeMoisInterDechet] ( moyenneVolume, mois, idMois, idDechet)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('janvier', null),0)as numeric(8,2)),0)), 'janvier',1, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('février', null),0)as numeric(8,2)),0)), 'février',2, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mars', null),0)as numeric(8,2)),0)), 'mars',3, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('avril', null),0)as numeric(8,2)),0)), 'avril',4, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('mai', null),0)as numeric(8,2)),0)), 'mai',5, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juin', null),0)as numeric(8,2)),0)), 'juin',6, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('juillet', null),0)as numeric(8,2)),0)), 'juillet',7, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('août', null),0)as numeric(8,2)),0)), 'août',8, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('septembre', null),0)as numeric(8,2)),0)), 'septembre',9, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('octobre', null),0)as numeric(8,2)),0)), 'octobre',10, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('novembre', null),0)as numeric(8,2)),0)), 'novembre',11, 7

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 1, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 1
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 2, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 2
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 3, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 3
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 4, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 4
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 5, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 5
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 6, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 6
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcmoisDechet(null, 7, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurmois ('décembre', null),0)as numeric(8,2)),0)), 'décembre',12, 7
GO
/****** Object:  View [dbo].[statistiqueVolumeMoisParc]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeMoisParc] ( moyenneVolume, mois,idMois, idParcConteneur)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMois(c.idparcconteneur, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[statistiqueVolumeMoisParcDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[statistiqueVolumeMoisParcDechet] ( moyenneVolume, mois,idMois, idParcConteneur, idDechet)
AS
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'janvier') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('janvier', c.idparcconteneur),0)as numeric(8,2)),0)), 'janvier',1, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'février') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('février', c.idparcconteneur),0)as numeric(8,2)),0)), 'février',2, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'mars') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mars', c.idparcconteneur),0)as numeric(8,2)),0)), 'mars',3, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'avril') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('avril', c.idparcconteneur),0)as numeric(8,2)),0)), 'avril',4, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'mai') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('mai', c.idparcconteneur),0)as numeric(8,2)),0)), 'mai',5, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'juin') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juin', c.idparcconteneur),0)as numeric(8,2)),0)), 'juin',6, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'juillet') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('juillet', c.idparcconteneur),0)as numeric(8,2)),0)), 'juillet',7, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'août') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('août', c.idparcconteneur),0)as numeric(8,2)),0)), 'août',8, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'septembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('septembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'septembre',9, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'octobre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('octobre', c.idparcconteneur),0)as numeric(8,2)),0)), 'octobre',10, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'novembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('novembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'novembre',11, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot

UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 1, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 1
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 2, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 2
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 3, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 3
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 4, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 4
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 5, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 5
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 6, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 6
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
UNION
SELECT DISTINCT(coalesce(cast(cast(dbo.volumeParParcMoisDechet(c.idparcconteneur, 7, 'décembre') as numeric(8,2))
/NULLIF(dbo.diviseurMois ('décembre', c.idparcconteneur),0)as numeric(8,2)),0)), 'décembre',12, c.idparcconteneur, 7
FROM depot d
Join concerner c ON c.iddepot = d.iddepot
GO
/****** Object:  View [dbo].[v_auth]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_auth] (id, Login, Password, role)
AS
SELECT        idUtilisateur AS id, Login, Password, 1
FROM            Utilisateur
UNION
SELECT        idMenage AS id, Login, Password, 0
FROM            MENAGE;
GO