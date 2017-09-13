/****** Object:  UserDefinedFunction [dbo].[diviseurJour]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[diviseurJour] (@periode VARCHAR(10), @idParc INTEGER)
RETURNS integer
AS
BEGIN
DECLARE @diviseur integer

	IF @idParc IS NOT NULL
	BEGIN
	SELECT @diviseur = COUNT (DISTINCT CAST(d.date AS DATE))
	FROM Depot d
	join concerner c on c.iddepot = d.iddepot
	join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
	WHERE DATENAME(dw, CAST(d.date AS DATE)) LIKE @periode 
	AND c.idparcconteneur = @idParc
	END
	ELSE
	BEGIN
	SELECT @diviseur = COUNT (DISTINCT CAST(d.date AS DATE))
	FROM Depot d
	join concerner c on c.iddepot = d.iddepot
	join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
	WHERE DATENAME(dw, CAST(d.date AS DATE)) LIKE @periode
	END
	return @diviseur
END
GO
/****** Object:  UserDefinedFunction [dbo].[diviseurMois]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[diviseurMois] (@periode VARCHAR(10), @idParc INTEGER)
RETURNS integer
AS
BEGIN
DECLARE @diviseur integer

	IF @idParc IS NOT NULL
	BEGIN
	SELECT @diviseur = COUNT(DISTINCT CONCAT(CONCAT(DATEPART(mm, d.date), ' '), DATEPART(yy, d.date)))
	FROM Depot d
	join concerner c on c.iddepot = d.iddepot
	join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
	WHERE DATENAME(mm, CAST(d.date AS DATE)) LIKE @periode 
	AND c.idparcconteneur = @idParc
	END
	ELSE
	BEGIN
	SELECT @diviseur = COUNT(DISTINCT CONCAT(CONCAT(DATEPART(mm, d.date), ' '), DATEPART(yy, d.date)))
	FROM Depot d
	WHERE DATENAME(mm, CAST(d.date AS DATE)) LIKE @periode
	END
	return @diviseur
END
GO
/****** Object:  UserDefinedFunction [dbo].[goFacture]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[goFacture] ()
RETURNS integer
AS
BEGIN

DECLARE @result integer
EXEC genererFacture @result output


return @result

END
GO
/****** Object:  UserDefinedFunction [dbo].[visiteParParcJour]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[visiteParParcJour] (@idparc integer, @jour varchar (10))
RETURNS integer
AS BEGIN

 DECLARE @result integer

 IF @idParc IS NOT NULL
	BEGIN

		 SELECT @result = count(distinct(c.iddepot)) 
		 from depot d
		 join concerner c on c.IdDepot = d.iddepot
		 WHERE c.IdParcConteneur = @idparc
		 AND datename(dw,cast(d.date as date)) like @jour
		
	END
	ELSE
	BEGIN 

	SELECT @result = count(d.iddepot) 
		 from depot d
		 WHERE  datename(dw,cast(d.date as date)) like @jour
		

	END

	 return @result
END
GO
/****** Object:  UserDefinedFunction [dbo].[visiteParParcMois]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[visiteParParcMois] (@idparc integer, @mois varchar (10))
RETURNS integer
AS BEGIN

 DECLARE @result integer
 IF @idParc IS NOT NULL
	BEGIN

	 SELECT @result = count(Distinct(c.iddepot) )
	 from concerner c
	 Join depot d ON d.iddepot = c.iddepot
	 WHERE c.IdParcConteneur = @idparc
	 AND datename(mm,cast(d.date as date)) like @mois
	 
	 
	 END
	 ELSE
	 BEGIN
		SELECT @result = count(d.iddepot) 
	 from depot d
	 WHERE datename(mm,cast(d.date as date)) like @mois
	 END

	 return @result

 END
GO
/****** Object:  UserDefinedFunction [dbo].[volumeParParcJour]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[volumeParParcJour] (@idparc integer, @jour varchar (10))
RETURNS Numeric(8,2)
AS BEGIN

DECLARE @result Numeric(8,2)

	 IF @idParc IS NOT NULL
		BEGIN
			SELECT @result = sum(c.volume) 
			from Concerner c
			join depot d on c.IdDepot = d.iddepot
			join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
			WHERE c.IdParcConteneur = @idparc
			AND datename(dw,cast(d.date as date)) like @jour
		END
 	ELSE
		BEGIN
			SELECT @result = SUM(c.volume)
			FROM concerner c
			join depot d on d.iddepot = c.iddepot
			WHERE DATENAME(dw, CAST(d.date AS DATE)) LIKE @jour
		END
	IF @result = null 
		BEGIN
			return 0.0
		END
		return @result
 END
GO
/****** Object:  UserDefinedFunction [dbo].[volumeParParcJourDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[volumeParParcJourDechet] (@idparc integer, @iddechet integer,  @jour varchar (10))
RETURNS Numeric(8,2)
AS BEGIN

DECLARE @result Numeric(8,2)

	 IF @idParc IS NOT NULL
		BEGIN
			SELECT @result = sum(c.volume) 
			from Concerner c
			join depot d on c.IdDepot = d.iddepot
			join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
			WHERE c.IdParcConteneur = @idparc
			AND c.idtypedechet = @iddechet
			AND datename(dw,cast(d.date as date)) like @jour
		END
 	ELSE
		BEGIN
			SELECT @result = SUM(c.volume)
			FROM concerner c
			join depot d on d.iddepot = c.iddepot
			WHERE DATENAME(dw, CAST(d.date AS DATE)) LIKE @jour
			AND c.idtypedechet = @iddechet
		END
	IF @result = null 
		BEGIN
			return 0.0
		END
		return @result
 END
GO
/****** Object:  UserDefinedFunction [dbo].[volumeParParcMois]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[volumeParParcMois] (@idparc integer, @mois varchar (10))
RETURNS Numeric(8,2)
AS BEGIN

DECLARE @result Numeric(8,2)

	 IF @idParc IS NOT NULL
		BEGIN
			SELECT @result = sum(c.volume) 
			from Concerner c
			join depot d on c.IdDepot = d.iddepot
			join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
			WHERE c.IdParcConteneur = @idparc
			AND datename(mm,cast(d.date as date)) like @mois
		END
 	ELSE
		BEGIN
			SELECT @result = SUM(c.volume)
			FROM concerner c
			join depot d on d.iddepot = c.iddepot
			WHERE DATENAME(mm, CAST(d.date AS DATE)) LIKE @mois
		END
	IF @result = null 
		BEGIN
			return 0.0
		END
		return @result
 END

GO
/****** Object:  UserDefinedFunction [dbo].[volumeParParcMoisDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[volumeParParcMoisDechet] (@idparc integer,@iddechet integer, @mois varchar (10))
RETURNS Numeric(8,2)
AS BEGIN

DECLARE @result Numeric(8,2)

	 IF @idParc IS NOT NULL
		BEGIN
			SELECT @result = sum(c.volume) 
			from Concerner c
			join depot d on c.IdDepot = d.iddepot
			join parcconteneur pc ON pc.idparcconteneur = c.idparcconteneur
			WHERE c.IdParcConteneur = @idparc
			AND c.idtypedechet = @iddechet
			AND datename(mm,cast(d.date as date)) like @mois
		END
 	ELSE
		BEGIN
			SELECT @result = SUM(c.volume)
			FROM concerner c
			join depot d on d.iddepot = c.iddepot
			WHERE DATENAME(mm, CAST(d.date AS DATE)) LIKE @mois
			AND c.idtypedechet = @iddechet
		END
	IF @result = null 
		BEGIN
			return 0.0
		END
		return @result
 END
GO
