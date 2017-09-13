/****** Object:  Table [dbo].[coefficient]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[coefficient](
	[idCoefficient] [int] NOT NULL,
	[coefficient] [numeric](4, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[idCoefficient] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Commune]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Commune](
	[IdCommune] [int] NOT NULL,
	[Nom] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCommune] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Concerner]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Concerner](
	[IdDepot] [int] NOT NULL,
	[IdTypeDechet] [int] NOT NULL,
	[Volume] [numeric](3, 1) NOT NULL,
	[IdParcConteneur] [int] NOT NULL,
 CONSTRAINT [PK_Concerner] PRIMARY KEY CLUSTERED 
(
	[IdDepot] ASC,
	[IdTypeDechet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Conteneur]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conteneur](
	[IdConteneur] [int] NOT NULL,
	[NumEmplacement] [numeric](2, 0) NOT NULL,
	[Capacite] [numeric](4, 1) NOT NULL,
	[VolumeUtilise] [numeric](4, 1) NOT NULL,
	[IdTypeDechet] [int] NOT NULL,
	[IdParcConteneur] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdConteneur] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Depot]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Depot](
	[IdDepot] [int] IDENTITY(1,1) NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[IdMenage] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDepot] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[derniereFacturation]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[derniereFacturation](
	[DateFacturation] [smalldatetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DetailFacture]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DetailFacture](
	[IdDetailFacture] [int] IDENTITY(1,1) NOT NULL,
	[Quantite] [numeric](4, 1) NULL,
	[Type] [char](1) NOT NULL,
	[Montant] [numeric](6, 1) NOT NULL,
	[IdTypeDechet] [int] NOT NULL,
	[IdFacture] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDetailFacture] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Facture]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Facture](
	[IdFacture] [int] IDENTITY(1,1) NOT NULL,
	[DateFacture] [smalldatetime] NOT NULL,
	[DateEcheance] [smalldatetime] NOT NULL,
	[Montant] [numeric](6, 1) NOT NULL,
	[StatutPayement] [char](1) NOT NULL,
	[IdMenage] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdFacture] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[forfait]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[forfait](
	[idForfait] [int] IDENTITY(1,1) NOT NULL,
	[idTypeDechet] [int] NOT NULL,
	[idsurplus] [int] NOT NULL,
	[montantforfait] [numeric](4, 2) NOT NULL,
	[variable] [numeric](4, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idForfait] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Menage]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Menage](
	[IdMenage] [int] IDENTITY(1,1) NOT NULL,
	[NomContact] [varchar](50) NOT NULL,
	[PrenomContact] [varchar](50) NOT NULL,
	[EmailContact] [varchar](100) NOT NULL,
	[Rue] [varchar](100) NOT NULL,
	[Numero] [varchar](5) NOT NULL,
	[Boite] [varchar](2) NULL,
	[CodePostal] [numeric](4, 0) NOT NULL,
	[Localite] [varchar](100) NOT NULL,
	[NbreAdultes] [numeric](2, 0) NOT NULL,
	[NbreEnfants] [numeric](2, 0) NOT NULL,
	[Login] [varchar](50) NULL,
	[Password] [char](42) NULL,
	[IdCommune] [int] NOT NULL,
	[idCoefficient] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdMenage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Notification]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Notification](
	[IdNotification] [int] NOT NULL,
	[DateNotification] [smalldatetime] NOT NULL,
	[Texte] [varchar](1000) NOT NULL,
	[IdMenage] [int] NULL,
	[IdConteneur] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdNotification] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ParcConteneur]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ParcConteneur](
	[IdParcConteneur] [int] NOT NULL,
	[Telephone] [varchar](20) NOT NULL,
	[Rue] [varchar](100) NOT NULL,
	[Numero] [varchar](5) NOT NULL,
	[Boite] [varchar](2) NULL,
	[CodePostal] [numeric](4, 0) NOT NULL,
	[Localite] [varchar](100) NOT NULL,
	[IdCommune] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdParcConteneur] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[IdRole] [int] NOT NULL,
	[Libelle] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdRole] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[surplus]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[surplus](
	[idSurplus] [int] NOT NULL,
	[pourcentageMax] [numeric](6, 2) NOT NULL,
	[pourcentageMin] [numeric](6, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[idSurplus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TypeDechet]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TypeDechet](
	[IdTypeDechet] [int] NOT NULL,
	[Nom] [varchar](100) NOT NULL,
	[QuotaAnnuel] [numeric](4, 1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTypeDechet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Utilisateur]    Script Date: 22-05-15 17:54:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Utilisateur](
	[IdUtilisateur] [int] NOT NULL,
	[Nom] [varchar](50) NOT NULL,
	[Prenom] [varchar](50) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Password] [char](42) NOT NULL,
	[IdParcConteneur] [int] NULL,
	[IdRole] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUtilisateur] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Concerner]  WITH CHECK ADD FOREIGN KEY([IdDepot])
REFERENCES [dbo].[Depot] ([IdDepot])
GO
ALTER TABLE [dbo].[Concerner]  WITH CHECK ADD FOREIGN KEY([IdParcConteneur])
REFERENCES [dbo].[ParcConteneur] ([IdParcConteneur])
GO
ALTER TABLE [dbo].[Concerner]  WITH CHECK ADD FOREIGN KEY([IdTypeDechet])
REFERENCES [dbo].[TypeDechet] ([IdTypeDechet])
GO
ALTER TABLE [dbo].[Conteneur]  WITH CHECK ADD FOREIGN KEY([IdParcConteneur])
REFERENCES [dbo].[ParcConteneur] ([IdParcConteneur])
GO
ALTER TABLE [dbo].[Conteneur]  WITH CHECK ADD FOREIGN KEY([IdTypeDechet])
REFERENCES [dbo].[TypeDechet] ([IdTypeDechet])
GO
ALTER TABLE [dbo].[Depot]  WITH CHECK ADD FOREIGN KEY([IdMenage])
REFERENCES [dbo].[Menage] ([IdMenage])
GO
ALTER TABLE [dbo].[DetailFacture]  WITH CHECK ADD FOREIGN KEY([IdFacture])
REFERENCES [dbo].[Facture] ([IdFacture])
GO
ALTER TABLE [dbo].[DetailFacture]  WITH CHECK ADD FOREIGN KEY([IdTypeDechet])
REFERENCES [dbo].[TypeDechet] ([IdTypeDechet])
GO
ALTER TABLE [dbo].[Facture]  WITH CHECK ADD FOREIGN KEY([IdMenage])
REFERENCES [dbo].[Menage] ([IdMenage])
GO
ALTER TABLE [dbo].[forfait]  WITH CHECK ADD FOREIGN KEY([idsurplus])
REFERENCES [dbo].[surplus] ([idSurplus])
GO
ALTER TABLE [dbo].[forfait]  WITH CHECK ADD FOREIGN KEY([idTypeDechet])
REFERENCES [dbo].[TypeDechet] ([IdTypeDechet])
GO
ALTER TABLE [dbo].[Menage]  WITH CHECK ADD FOREIGN KEY([idCoefficient])
REFERENCES [dbo].[coefficient] ([idCoefficient])
GO
ALTER TABLE [dbo].[Menage]  WITH CHECK ADD FOREIGN KEY([IdCommune])
REFERENCES [dbo].[Commune] ([IdCommune])
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD FOREIGN KEY([IdConteneur])
REFERENCES [dbo].[Conteneur] ([IdConteneur])
GO
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD FOREIGN KEY([IdMenage])
REFERENCES [dbo].[Menage] ([IdMenage])
GO
ALTER TABLE [dbo].[ParcConteneur]  WITH CHECK ADD FOREIGN KEY([IdCommune])
REFERENCES [dbo].[Commune] ([IdCommune])
GO
ALTER TABLE [dbo].[Utilisateur]  WITH CHECK ADD FOREIGN KEY([IdParcConteneur])
REFERENCES [dbo].[ParcConteneur] ([IdParcConteneur])
GO
ALTER TABLE [dbo].[Utilisateur]  WITH CHECK ADD FOREIGN KEY([IdRole])
REFERENCES [dbo].[Role] ([IdRole])
GO
ALTER TABLE [dbo].[DetailFacture]  WITH CHECK ADD  CONSTRAINT [Type_F_V] CHECK  (([Type]='V' OR [Type]='F'))
GO
ALTER TABLE [dbo].[DetailFacture] CHECK CONSTRAINT [Type_F_V]
GO
ALTER TABLE [dbo].[Facture]  WITH CHECK ADD  CONSTRAINT [StatutPayement_N_P] CHECK  (([StatutPayement]='P' OR [StatutPayement]='N'))
GO
ALTER TABLE [dbo].[Facture] CHECK CONSTRAINT [StatutPayement_N_P]
GO
ALTER TABLE [dbo].[Menage]  WITH CHECK ADD  CONSTRAINT [Champs_valide] CHECK  ((len([nomcontact])>(1) AND len([prenomcontact])>(1) AND len([rue])>(1) AND [nbreadultes]>(0) AND [nbreenfants]>=(0)))
GO
ALTER TABLE [dbo].[Menage] CHECK CONSTRAINT [Champs_valide]
GO
ALTER TABLE [dbo].[Menage]  WITH CHECK ADD  CONSTRAINT [email_valide] CHECK  (([emailcontact] like '%@%.%'))
GO
ALTER TABLE [dbo].[Menage] CHECK CONSTRAINT [email_valide]
GO

