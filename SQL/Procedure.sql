/****** Object:  StoredProcedure [dbo].[calculPourcentage]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[calculPourcentage] (@idmenage integer, @volume numeric(4,1),@idtypedechet integer)
AS

SELECT 

coalesce (CAST(ROUND((
			--On va recherché le volume déposé
			SELECT coalesce(SUM(c.volume),0.0) + @volume 
			FROM concerner c 
			JOIN depot d ON d.iddepot = c.iddepot
			JOIN menage m ON m.idmenage =d.idmenage
			WHERE @idtypedechet = c.idtypedechet and m.idmenage = @idmenage)/
			--Divisé par le quota annuel autorisé corrigé
			(SELECT quotaannuel
			FROM typedechet 
			WHERE @idtypedechet = idtypedechet)*
			(SELECT co.coefficient 
			FROM coefficient co 
			JOIN menage m ON m.idcoefficient = co.idcoefficient 
			WHERE m.idmenage = @idmenage)*100,2,0)as decimal(18,2)),0)
GO
/****** Object:  StoredProcedure [dbo].[catch_user_data]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[catch_user_data] @user VARCHAR(100), @password VARCHAR(100)
AS
DECLARE @id int
DECLARE @role int
SELECT @id = id, @role = idRole
FROM v_auth
WHERE login like @user
AND CONVERT(VARCHAR(100),HASHBYTES('SHA1',@password),1) LIKE password
IF @role < 4 SELECT * FROM Utilisateur WHERE @id = idUtilisateur
ELSE IF @role = 4  SELECT * , 4 AS Role FROM MENAGE WHERE @id = idMenage
ELSE RAISERROR('BAD_AUTH', 16, 1)


SELECT * FROM Utilisateur


SELECT * FROM v_auth


SELECT id, idRole
FROM v_auth
WHERE login LIKE 'keynechristiaens1'
AND CONVERT(VARCHAR(100),HASHBYTES('SHA1','y\"h#sP|e'),1) LIKE password

SELECT * FROM MENAGE

SELECT c.IdCommune, c.Nom, p.Localite FROM Commune c 
INNER JOIN ParcConteneur p ON c.IdCommune = p.IdCommune
GROUP BY c.IdCommune, c.Nom, p.Localite‏
GO
/****** Object:  StoredProcedure [dbo].[envoi_Email]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[envoi_Email] @email VARCHAR(100), @sujet VARCHAR(200),@content VARCHAR(2000) 
AS
	EXEC msdb.dbo.sp_send_dbmail @profile_name='sqlmail',
	@recipients=@email,
	@subject = @sujet,
	@body = @content,
	@body_format = 'HTML'
GO
/****** Object:  StoredProcedure [dbo].[fetch_role]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[fetch_role]
AS
SELECT * FROM ROLE
GO
/****** Object:  StoredProcedure [dbo].[genererFacture]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[genererFacture] 

AS
BEGIN

	declare @idmenage integer
	
	DECLARE curseurMenage CURSOR
	FOR SELECT distinct(idmenage) from quota where volume_restant < 0 and idtypedechet < 6
	

	Open curseurmenage
	FETCH curseurmenage into @idmenage
	WHILE @@fetch_status = 0
	BEGIN
		IF (Select count(idfacture) from facture where idmenage = @idmenage 
		and cast(dateFacture as date) = cast(getdate() as date)) = 0 
		
		BEGIN
			INSERT INTO Facture (dateFacture, DateEcheance, Montant, StatutPayement, IdMenage)
			VALUES (getdate(),getdate()+15, (SELECT (sum(montantforfait)) + sum(prixVariable) 
												from detailFacturation
												WHERE idmenage = @idmenage
												AND idtypedechet < 6
												), 'N', @idmenage)

			Declare @email varchar(100) = (SELECT emailcontact from menage where idmenage = @idmenage)

			DELETE FROM notification where idmenage = @idmenage
			INSERT INTO Notification (Idnotification, DateNotification, Texte, IdMenage) 
			VALUES ((SELECT ISNULL(MAX(idnotification)+1,1) from notification),getdate(),'Votre facture est disponible',@idmenage);
			EXECUTE envoi_Email @email, 'Votre facture RecyZone est disponible', 'Bonjour ,<br/><br/>Votre facture RecyZone est disponible depuis votre application<br/><br/> A bientôt<br/>L''équipe RecyZone'

			

		END
		FETCH curseurmenage into @idmenage
	END

	Close curseurmenage
	deallocate curseurmenage

	INSERT INTO dernierefacturation values (getdate())

	
END
GO
