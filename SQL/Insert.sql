USE [in14b1124]
GO
INSERT [dbo].[Role] ([IdRole], [Libelle]) VALUES (1, N'Gérant Intercommunale')
GO
INSERT [dbo].[Role] ([IdRole], [Libelle]) VALUES (2, N'Gérant Parc')
GO
INSERT [dbo].[Role] ([IdRole], [Libelle]) VALUES (3, N'Employé Parc')
GO
INSERT [dbo].[Commune] ([IdCommune], [Nom]) VALUES (1, N'Liège')
GO
INSERT [dbo].[Commune] ([IdCommune], [Nom]) VALUES (2, N'Pepinster')
GO
INSERT [dbo].[Commune] ([IdCommune], [Nom]) VALUES (3, N'Fléron')
GO
INSERT [dbo].[Commune] ([IdCommune], [Nom]) VALUES (4, N'Herve')
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (1, N'04/221.23.56', N'Rue du Péry', N'14', NULL, CAST(4000 AS Numeric(4, 0)), N'Liège', 1)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (2, N'04/220.53.49', N'Avenue de l''Avenir', N'45', NULL, CAST(4020 AS Numeric(4, 0)), N'Wandre', 1)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (3, N'04/220.76.29', N'Rue Georges Crolon', N'5', NULL, CAST(4031 AS Numeric(4, 0)), N'Angleur', 1)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (4, N'04/221.14.15', N'Rue du Tir', N'78', NULL, CAST(4020 AS Numeric(4, 0)), N'Liège', 1)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (5, N'087/46.59.23', N'Avenue des Libertés', N'4', NULL, CAST(4860 AS Numeric(4, 0)), N'Pepinster', 2)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (6, N'087/12.15.69', N'Rue des Clochers', N'56', NULL, CAST(4861 AS Numeric(4, 0)), N'Soiron', 2)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (7, N'04/355.25.19', N'Rue de la Fosse', N'78', NULL, CAST(4620 AS Numeric(4, 0)), N'Fléron', 3)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (8, N'04/355.78.61', N'Rue des Gaillettes', N'95', NULL, CAST(4624 AS Numeric(4, 0)), N'Romsée', 3)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (9, N'087/69.36.56', N'Rue Jean-Marie Sitter', N'45', NULL, CAST(4650 AS Numeric(4, 0)), N'Herve', 4)
GO
INSERT [dbo].[ParcConteneur] ([IdParcConteneur], [Telephone], [Rue], [Numero], [Boite], [CodePostal], [Localite], [IdCommune]) VALUES (10, N'087/69.12.13', N'Avenue du Cardon', N'9', NULL, CAST(4652 AS Numeric(4, 0)), N'Xhendelesse', 4)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (1, N'Hérant', N'Guillaume', N'g.herant@recyzone.be', N'gherant', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', NULL, 1)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (2, N'Joiris', N'Luc', N'l.joiris@recyzone.be', N'ljoiris', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 1, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (3, N'Turbal', N'Guy', N'g.turbal@recyzone.be', N'gturbal', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 1, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (4, N'Bigot', N'Marie', N'm.bigot@recyzone.be', N'mbigot', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 1, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (5, N'Janlet', N'Myriam', N'm.janlet@recyzone.be', N'mjanlet', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 2, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (6, N'Hurot', N'Martin', N'm.hurot@recyzone.be', N'mhurot', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 2, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (7, N'Bichat', N'Pauline', N'p.bichat@recyzone.be', N'pbichat', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 2, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (8, N'Dutour', N'Sophie', N's.dutour@recyzone.be', N'sdutour', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 3, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (9, N'Janlet', N'Marc', N'ma.janlet@recyzone.be', N'majanlet', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 3, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (10, N'Brasson', N'Guillaume', N'g.brasson@recyzone.be', N'gbrasson', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 3, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (11, N'Oligat', N'Marc', N'm.oligat@recyzone.be', N'moligat', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 4, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (12, N'Krupper', N'Mario', N'm.krupper@recyzone.be', N'mkrupper', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 4, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (13, N'Vandeberg', N'Pierre', N'p.vandeberg@recyzone.be', N'pvandeberg', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 5, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (14, N'Sitro', N'Maria', N'm.sitro@recyzone.be', N'msitro', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 5, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (15, N'Jaminet', N'Paul', N'p.jaminet@recyzone.be', N'pjaminet', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 6, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (16, N'Bryon', N'Sylvie', N's.bryon@recyzone.be', N'sbryon', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 6, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (17, N'Lacasse', N'Martine', N'm.lacasse@recyzone.be', N'mlacasse', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 7, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (18, N'Paulus', N'Sergio', N's.paulus@recyzone.be', N'spaulus', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 7, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (19, N'Drion', N'Brigitte', N'b.drion@recyzone.be', N'bdrion', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 8, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (20, N'Demoulin', N'Serge', N's.demoulin@recyzone.be', N'sdemoulin', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 8, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (21, N'Duchamp', N'Pierre', N'p.duchamp@recyzone.be', N'pduchamp', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 9, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (22, N'Franzi', N'Marc', N'm.franzi@recyzone.be', N'mfranzi', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 9, 3)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (23, N'Douagou', N'Marceline', N'm.douagou@recyzone.be', N'mdouagou', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 10, 2)
GO
INSERT [dbo].[Utilisateur] ([IdUtilisateur], [Nom], [Prenom], [Email], [Login], [Password], [IdParcConteneur], [IdRole]) VALUES (24, N'Duroux', N'Nathalie', N'n.duroux@recyzone.be', N'nduroux', N'0x9CF95DACD226DCF43DA376CDB6CBBA7035218921', 10, 3)
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (1, N'Déchets de jardin', CAST(13.0 AS Numeric(4, 1)))
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (2, N'Encombrants', CAST(4.0 AS Numeric(4, 1)))
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (3, N'Bois', CAST(3.0 AS Numeric(4, 1)))
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (4, N'Briques et briquaillons', CAST(2.5 AS Numeric(4, 1)))
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (5, N'Terres et sable', CAST(2.5 AS Numeric(4, 1)))
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (6, N'Métaux', NULL)
GO
INSERT [dbo].[TypeDechet] ([IdTypeDechet], [Nom], [QuotaAnnuel]) VALUES (7, N'Papiers-cartons', NULL)
GO
INSERT [dbo].[surplus] ([idSurplus], [pourcentageMax], [pourcentageMin]) VALUES (1, CAST(20.00 AS Numeric(6, 2)), CAST(0.00 AS Numeric(6, 2)))
GO
INSERT [dbo].[surplus] ([idSurplus], [pourcentageMax], [pourcentageMin]) VALUES (2, CAST(50.00 AS Numeric(6, 2)), CAST(50.01 AS Numeric(6, 2)))
GO
INSERT [dbo].[surplus] ([idSurplus], [pourcentageMax], [pourcentageMin]) VALUES (3, CAST(1000.00 AS Numeric(6, 2)), NULL)
GO
SET IDENTITY_INSERT [dbo].[forfait] ON 

GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (1, 1, 1, CAST(10.00 AS Numeric(4, 2)), CAST(2.50 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (2, 1, 2, CAST(20.00 AS Numeric(4, 2)), CAST(4.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (3, 1, 3, CAST(20.00 AS Numeric(4, 2)), CAST(4.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (4, 2, 1, CAST(15.00 AS Numeric(4, 2)), CAST(4.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (5, 2, 2, CAST(30.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (6, 2, 3, CAST(30.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (7, 3, 1, CAST(10.00 AS Numeric(4, 2)), CAST(4.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (8, 3, 2, CAST(20.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (9, 3, 3, CAST(20.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (10, 4, 1, CAST(7.50 AS Numeric(4, 2)), CAST(3.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (11, 4, 2, CAST(15.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (12, 4, 3, CAST(15.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (13, 5, 1, CAST(7.50 AS Numeric(4, 2)), CAST(3.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (14, 5, 2, CAST(15.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[forfait] ([idForfait], [idTypeDechet], [idsurplus], [montantforfait], [variable]) VALUES (15, 5, 3, CAST(15.00 AS Numeric(4, 2)), CAST(5.00 AS Numeric(4, 2)))
GO
SET IDENTITY_INSERT [dbo].[forfait] OFF
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (1, CAST(1 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.5 AS Numeric(4, 1)), 1, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (2, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(22.0 AS Numeric(4, 1)), 1, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (3, CAST(3 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (4, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (5, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (6, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (7, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (8, CAST(8 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (9, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (10, CAST(10 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 1)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (11, CAST(1 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (12, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (13, CAST(3 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(26.0 AS Numeric(4, 1)), 3, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (14, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (15, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (16, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (17, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 2)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (18, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (19, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (20, CAST(3 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (21, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(21.0 AS Numeric(4, 1)), 4, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (22, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (23, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (24, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 3)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (25, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (26, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (27, CAST(3 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (28, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (29, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (30, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (31, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (32, CAST(8 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 4)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (33, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (34, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (35, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (36, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (37, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (38, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (39, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (40, CAST(8 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 5)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (41, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (42, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (43, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (44, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (45, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (46, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (47, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (48, CAST(8 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (49, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 6)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (50, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (51, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (52, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (53, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (54, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (55, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (56, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (57, CAST(8 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (58, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 7)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (59, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (60, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (61, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (62, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (63, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (64, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (65, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (66, CAST(8 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (67, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 8)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (68, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (69, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (70, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (71, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (72, CAST(5 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (73, CAST(6 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (74, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (75, CAST(8 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (76, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 9)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (77, CAST(1 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (78, CAST(2 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 1, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (79, CAST(3 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 2, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (80, CAST(4 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (81, CAST(5 AS Numeric(2, 0)), CAST(25.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 3, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (82, CAST(6 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 4, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (83, CAST(7 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 5, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (84, CAST(8 AS Numeric(2, 0)), CAST(50.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 6, 10)
GO
INSERT [dbo].[Conteneur] ([IdConteneur], [NumEmplacement], [Capacite], [VolumeUtilise], [IdTypeDechet], [IdParcConteneur]) VALUES (85, CAST(9 AS Numeric(2, 0)), CAST(40.0 AS Numeric(4, 1)), CAST(0.0 AS Numeric(4, 1)), 7, 10)
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (10, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (11, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (12, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (13, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (14, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (15, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (16, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (17, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (18, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (19, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (20, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (21, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (22, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (23, CAST(1.00 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (24, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (25, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (26, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (27, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (28, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (29, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (30, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (31, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (32, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (33, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (34, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (35, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (36, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (37, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (38, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (39, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (40, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (41, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (42, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (43, CAST(1.05 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (44, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (45, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (46, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (47, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (48, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (49, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (50, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (51, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (52, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (53, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (54, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (55, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (56, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (57, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (58, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (59, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (60, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (61, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (62, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (63, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (64, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (65, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (66, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (67, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (68, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (69, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (70, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (71, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (72, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (73, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (74, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (75, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (76, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (77, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (78, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (79, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (80, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (81, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (82, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (83, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (84, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (85, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (86, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (87, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (88, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (89, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (90, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (91, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (92, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (93, CAST(1.10 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (94, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (95, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (96, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (97, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (98, CAST(1.15 AS Numeric(4, 2)))
GO
INSERT [dbo].[coefficient] ([idCoefficient], [coefficient]) VALUES (99, CAST(1.15 AS Numeric(4, 2)))
GO
