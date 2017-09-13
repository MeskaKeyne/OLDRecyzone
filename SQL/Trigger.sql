/****** Object:  Trigger [dbo].[notificationMenage]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[notificationMenage] ON [dbo].[Concerner]
AFTER INSERT
AS BEGIN

	DECLARE @idmenage integer
	DECLARE @iddepot integer
	DECLARE @date smalldatetime
	DECLARE @volume numeric (4,2)
	DECLARE @idtypedechet integer

	SELECT @volume = volume from inserted
	SELECT @iddepot = iddepot from inserted
	SELECT @idmenage = idmenage from depot Where iddepot = @iddepot
	SELECT @date = date from depot Where iddepot = @iddepot
	SELECT @idtypedechet = idtypedechet from inserted


	IF (SELECT volume_restant from quota where idmenage = @idmenage and idtypedechet = @idtypedechet) < 0 
	AND (SELECT count(idnotification) from notification where idmenage = @idmenage ) = 0
	BEGIN
		INSERT INTO Notification (Idnotification, DateNotification, Texte, IdMenage) 
		VALUES ((SELECT MAX (idnotification)+1 from notification),@Date,'Vous avez dépassé votre quota annuel',@idmenage);

	END

END
GO
/****** Object:  Trigger [dbo].[verification_concerner]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[verification_concerner] ON [dbo].[Concerner]
AFTER INSERT
AS
BEGIN

	Declare @volume numeric(3,1)
	Declare @idTypedechet integer
	Declare @iddepot integer
	Declare @idparcconteneur integer
	Declare @date smalldatetime

	SELECT @volume = volume from inserted
	Select @idtypedechet = idtypedechet from inserted
	select @iddepot = iddepot from inserted
	select @idparcconteneur = idparcconteneur from inserted
	select @date = date from depot where iddepot = @iddepot

	IF @volume > 4 OR @volume <=0
	BEGIN 

		RAISERROR('[verification_concerner] Le volume dépasse la limite autorisée ou est plus petit ou égal à 0', 7, 1)
		
		ROLLBACK TRANSACTION
		RETURN
	END
	--quota quotidien
		IF (select sum(c.volume) from concerner c join depot d on d.iddepot = c.iddepot where c.iddepot = @iddepot AND cast(d.date as date) = cast(@date as date))> 4
		BEGIN
			RAISERROR('[verification_quota] Vous avez déjà effectué trop de depots aujourd''hui pour pouvoir déposer ces déchets', 7, 1)
		 
			ROLLBACK TRANSACTION
			RETURN
		END

		--quota hebdomadaire
		IF (select sum(c.volume) from concerner c join depot d on d.iddepot = c.iddepot 
		where c.iddepot = @iddepot AND  cast(d.date as date) Between cast(@date-7 as date) AND cast(@date as date)) > 15
		BEGIN
			RAISERROR('[verification_quota] Vous avez déjà effectué trop de depots cette semaine pour pouvoir déposer ces déchets', 7, 1)
		
			ROLLBACK TRANSACTION
			RETURN
		END 

	IF (SELECT MAX(capacite - volumeutilise) from conteneur where idtypedechet = @idtypedechet AND idParcConteneur = @idparcconteneur) < @volume
	BEGIN
		RAISERROR('[verification_concerner] Tous les conteneurs sont plein', 7, 1)
		
		ROLLBACK TRANSACTION
		RETURN
	END
	ELSE
	BEGIN

		UPDATE conteneur set volumeUtilise += @volume
		WHERE idtypedechet = @idtypedechet AND idParcConteneur = @idparcconteneur AND idconteneur =  (SELECT top 1 idconteneur from conteneur where (capacite - volumeutilise) >= @volume)
	END
END
GO
/****** Object:  Trigger [dbo].[delNotifAfterTournee]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[delNotifAfterTournee] ON [dbo].[Conteneur]
/*Après un update, supprime la notifications qui lui sont liés*/ 
	AFTER UPDATE
	AS BEGIN	
		
		DECLARE @idConteneur INTEGER
		
		DECLARE @volumeUtilise NUMERIC(4,1)
		
		
			
		SELECT @idConteneur = idConteneur, @volumeUtilise = volumeUtilise 
		FROM inserted
			
		if @volumeUtilise = 0
		BEGIN
			
		DELETE FROM Notification WHERE idConteneur = @idConteneur
			
		END
			
	END
GO
/****** Object:  Trigger [dbo].[Verif_quota]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Verif_quota] ON [dbo].[Conteneur]
AFTER UPDATE
-- =============================================
-- Author:		<Rouschop, Lyratashi, Tomagra>
-- Create date: <Create Date,,>
-- Description:	<Génère un mail et une notification si un conteneur atteint 80 ou 95%>

-- A améliorer
-- =============================================
AS 
BEGIN
	
	DECLARE @id_conteneur Integer 
	DECLARE @Capacite numeric(4,1) 
	DECLARE @VolumeUtilise numeric(4,1) 
	DECLARE @idParcCont Integer
	DECLARE @idTypeDechet Integer
	DECLARE @typeDechet varchar(255)
	DECLARE @email VARCHAR(100)
	DECLARE @sujet VARCHAR(200)
	DECLARE @content VARCHAR(2000)
	DECLARE @Date SMALLDATETIME
	DECLARE @Texte Varchar(1000)
	
	
	DECLARE @idsuivant Integer
	DECLARE @idNotif Integer

	
	SELECT @idNotif = MAX(IdNotification)+1 FROM Notification
	SELECT @idsuivant = ISNULL(@idNotif,1)
	SELECT @DATE = GETDATE()
	SELECT @id_conteneur = idConteneur FROM inserted
	SELECT @Capacite = Capacite FROM inserted
	SELECT @VolumeUtilise = Volumeutilise FROM inserted
	SELECT @idParcCont = idParcConteneur FROM inserted
	SELECT @idTypeDechet = idTypeDechet FROM inserted
	
		--Retourne le type de déchat où le container est plein
	SELECT @typeDechet =  nom FROM TypeDechet WHERE idTypeDechet = @idTypeDechet
	SELECT @email = email from utilisateur where idrole = 1

	IF @VolumeUtilise > @capacite
	BEGIN
		RAISERROR('[Verif_quota] Impossible de dépasser la capacité du conteneur', 7, 1)
		ROLLBACK TRANSACTION
		RETURN
	END


        
	
	IF ( @VolumeUtilise >= (@Capacite*0.8) AND (SELECT count(idnotification) from notification where idconteneur = @id_conteneur ) = 0) 
	BEGIN
		SELECT @sujet = 'Capacité du conteneur d''id : '+cast(@id_conteneur as varchar(3))+' a atteint la limite de quota de 80%'
		SELECT @content ='Bonjour,Le conteneur comportant le numéro d''id : '+cast(@id_conteneur as varchar(3))+' a dépassé la limite de 80%.Une notification à été envoyé automatiquement au gestionnaire du parc dont le numéro du parc est le suivant : '+cast(@idParcCont as varchar(3))+'.Un enlève-conteneur est attendu pour retirer des déchets de type : '+@typeDechet+'.'
		SELECT @Texte = 'Conteneur portant le numéro d''authentification  : ' +cast(@id_conteneur as varchar(3))+' a atteint la limite de 80%, il comporte des déchets de type '+@TypeDechet
	

		--Procedure mail 
		-- + notification sur la table notif. INSERT INTO cf. Base de donnée.

		--/!\ Envoyer un message concat. Reprenant toutes les infos

		EXECUTE envoi_Email @email, @sujet, @content

		INSERT INTO Notification (Idnotification, DateNotification, Texte, IdMenage, IdConteneur) VALUES (@idsuivant,@Date,@Texte,NULL,@id_conteneur);


	END

		IF ( @VolumeUtilise >= (@Capacite*0.95) AND (SELECT count(idnotification) from notification where idconteneur = @id_conteneur ) = 1)
	BEGIN
		SELECT @sujet = 'Capacité du conteneur d''id : '+cast(@id_conteneur as varchar(3))+' a atteint la limite de quota de 95%'
		SELECT @content ='Bonjour,Le conteneur comportant le numéro d''id : '+cast(@id_conteneur as varchar(3))+' a dépassé la limite de 95%.Une notification à été envoyé automatiquement au gestionnaire du parc dont le numéro du parc est le suivant : '+cast(@idParcCont as varchar(3))+'.Un enlève-conteneur est attendu pour retirer des déchets de type : '+@typeDechet+'.'
		SELECT @Texte = 'Conteneur portant le numéro d''authentification  : ' +cast(@id_conteneur as varchar(3))+' a atteint la limite de 95%, il comporte des déchets de type '+@TypeDechet
	

		--Procedure mail 
		-- + notification sur la table notif. INSERT INTO cf. Base de donnée.

		--/!\ Envoyer un message concat. Reprenant toutes les infos

		EXECUTE envoi_Email @email, @sujet, @content

		INSERT INTO Notification (Idnotification, DateNotification, Texte, IdMenage, IdConteneur) VALUES (@idsuivant,@Date,@Texte,NULL,@id_conteneur);


	END


	

	


END

GO
/****** Object:  Trigger [dbo].[verification_quota]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[verification_quota] ON [dbo].[Depot]
AFTER INSERT
AS
BEGIN

	DECLARE @idmenage integer
	declare @date smalldatetime

	SELECT @idmenage = idmenage from inserted
	select @date = date from inserted

	
	
		--verification depot unique par jour
		IF (select count (d.idmenage) from depot d where d.idmenage = @idmenage AND cast(d.date as date) = cast(@date as date)) > 1
		BEGIN
		
		RAISERROR('[verification_quota] Vous avez déjà effectué un passage au parc aujourd''hui', 7, 1)
		 
			ROLLBACK TRANSACTION
			RETURN
		END





END
GO
/****** Object:  Trigger [dbo].[generationDetailFacture]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[generationDetailFacture] On [dbo].[Facture]
AFTER INSERT
AS BEGIN

--Après une insert d'une facture : Insert un detail facture reprenant les infos 

DECLARE @IdFacture INTEGER
DECLARE @IdMenage Integer
DECLARE @IdDechet INTEGER

SELECT @IdFacture = idFacture From Inserted
SELECT @IdMenage = IdMenage FROM Inserted
 

DECLARE curseur CURSOR 
FOR SELECT IdtypeDechet 
FROM detailFacturation
WHERE idmenage = @idmenage

OPEN curseur
FETCH curseur INTO @IdDechet

While @@FETCH_STATUS = 0
BEGIN 

if @IdDechet < 6
BEGIN 

INSERT INTO DetailFacture(Type, Montant, idTypeDechet, IdFacture) Values( 'F', (SELECT MontantForfait FROM detailFacturation WHERE idTypeDechet = @IdDechet), @idDechet, @idFacture)
INSERT INTO DetailFacture(quantite, Type, Montant, idTypeDechet, IdFacture) Values( (SELECT exedant FROM detailFacturation WHERE idTypeDechet = @IdDechet), 'V', (SELECT prixVariable FROM detailFacturation WHERE @IdDechet = idTypeDechet), @idDechet, @idFacture)

END
FETCH curseur INTO @IdDechet
END

CLOSE curseur
DEALLOCATE curseur

END
GO
/****** Object:  Trigger [dbo].[suppressionNotif]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[suppressionNotif] ON [dbo].[Facture]
AFTER UPDATE
AS BEGIN

	DECLARE @idMenage integer
	DECLARE @StatutPayement char(1)

	SELECT @idmenage = idmenage from inserted
	SELECT @statutpayement = statutpayement from inserted

	if @statutpayement = 'P'
	BEGIN
	DELETE FROM notification where idmenage = @idmenage
	END
END
GO
/****** Object:  Trigger [dbo].[ajout_menage]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[ajout_menage] ON [dbo].[Menage]
AFTER INSERT
AS
BEGIN
	DECLARE @email varchar(100)
	DECLARE @login varchar(50)
	DECLARE @password varchar(10)
	DECLARE @passwordEncrypted varchar(100)
	DECLARE @id INTEGER
	DECLARE @boite varchar(2)


	SELECT @email = EmailContact FROM inserted
	SELECT @login = SUBSTRING((@email),1,CHARINDEX ('@',(@email))-1) --extraction de tout ce qui se trouve avant le @
	SELECT @password = char(26 * RAND() + 97) + 
						char(26 * RAND() + 97) + 
						char(26 * RAND() + 65) + 
						char(26 * RAND() + 65) + 
						char(10 * RAND() + 48) + 
						char(26 * RAND() + 97) + 
						char(10 * RAND() + 48) + 
						char(26 * RAND() + 65) --Génère un mot de passe aléatoire de 8 char
	SELECT @passwordEncrypted = CONVERT(VARCHAR(100),HASHBYTES('SHA1',@password),1) --Hashage du password
	SELECT @id = idMenage FROM inserted
	
	SELECT @boite = boite FROM inserted

	
		IF (SELECT COUNT (login)
			FROM v_auth
			WHERE Login LIKE @login) >0
		BEGIN
			
			SELECT @login = @login+CAST(@id as varchar(3)) --ajout de l'ID au login si il est déjà utilisé
			
		END

		

	UPDATE menage SET Login = @login, Password = @passwordEncrypted WHERE IdMenage = @id -- On insère le login et le password dans la table
	
	--On insère la valeur null pour la boite si c'est une chaine vide qui est entrée.
	IF @boite = ''
	BEGIN
		UPDATE menage SET boite = null WHERE idMenage = @id
	END
	
	--Envoie d'un email au client
	DECLARE @content varchar(1000)
	
	SELECT @content = 'Bienvenue chez RecyZone,<br/><br/>Votre identifiant est: '+@login+ '<br/>Votre mot de passe est: '+@password+'<br/><br/> A bientôt<br/>L''équipe RecyZone' -- construction du contenu de l'email
	EXECUTE envoi_Email @email, 'Votre identifiant et mot de passe', @content --On envoie son identifiant et mdp à l'utilisateur
END
GO
/****** Object:  Trigger [dbo].[check_localite]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[check_localite] ON [dbo].[Menage]
AFTER INSERT
AS BEGIN

	DECLARE @localite varchar(100)
	DECLARE @codePostal numeric(4,0)
	DECLARE @idCommune INTEGER

	SELECT @localite = localite From inserted
	SELECT @codePostal = codepostal FROM inserted 
	SELECT @idCommune = idCommune FROM inserted

	IF @localite NOT IN (SELECT localite FROM localiteCommune WHERE idCommune = @idCommune)
	BEGIN
		RAISERROR('[check_localite] La localité ou l''idCommune n''est pas correct', 7, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	IF @codePostal NOT IN (SELECT code_postal FROM localiteCommune WHERE idCommune = @idCommune)
	BEGIN
		RAISERROR('[check_localite] Le code postal ou l''idCommune n''est pas correct', 7, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

END
GO
/****** Object:  Trigger [dbo].[coefficientInsert]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[coefficientInsert] ON [dbo].[Menage]
AFTER INSERT
AS BEGIN

	DECLARE @nbreEnfants integer
	DECLARE @nbreAdultes integer
	DECLARE @idMenage integer

	SELECT @nbreEnfants = nbreEnfants FROM inserted
	SELECT @nbreAdultes = nbreAdultes FROM inserted
	Select @idMenage = idmenage from inserted

	IF @nbreEnfants > 9 OR @nbreAdultes >9
	BEGIN
		RAISERROR('[coefficientInsert] Le nombre maximum d''enfant ou d''adulte est dépassé', 7, 1)
		
		ROLLBACK TRANSACTION
		RETURN
	END
	ELSE 
	BEGIN
		declare @coefficientVar varchar(3) = cast(@nbreAdultes as varchar(2))+cast(@nbreEnfants as varchar(2))
		declare @coefficient integer = cast(@coefficientVar as integer)
		UPDATE menage SET idCoefficient = @coefficient
		WHERE idmenage = @idMenage
	END
	
END
GO
/****** Object:  Trigger [dbo].[coefficientUpdate]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[coefficientUpdate] ON [dbo].[Menage]
AFTER UPDATE
AS BEGIN

	DECLARE @nbreEnfants integer
	DECLARE @nbreAdultes integer
	DECLARE @idMenage integer

	SELECT @nbreEnfants = nbreEnfants FROM inserted
	SELECT @nbreAdultes = nbreAdultes FROM inserted
	Select @idMenage = idmenage from inserted

IF @nbreEnfants > 9 OR @nbreAdultes >9
	BEGIN
		RAISERROR('[coefficientInsert] Le nombre maximum d''enfant ou d''adulte est dépassé', 7, 1)
		
		ROLLBACK TRANSACTION
		RETURN
	END
	ELSE 
	BEGIN
		declare @coefficientVar varchar(3) = cast(@nbreAdultes as varchar(2))+cast(@nbreEnfants as varchar(2))
		declare @coefficient integer = cast(@coefficientVar as integer)
		UPDATE menage SET idCoefficient = @coefficient
		WHERE idmenage = @idMenage
	END
END
GO