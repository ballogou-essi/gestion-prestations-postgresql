----------------------------------------------------------------------------
----------------- Script de création des différentes tables ----------------
----------------------------------------------------------------------------

-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";


----------------------------------------------------------------------------
-------------------- Table N°1 : "OPE"."TB_TYPE_CLIENT" --------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_TYPE_CLIENT" CASCADE ;
CREATE TABLE "TB_TYPE_CLIENT" 
(
	"CD_TYPE_CLIENT" 		VARCHAR(10) NOT NULL,
	"LB_TYPE_CLIENT" 		VARCHAR(50) NOT NULL,
	UNIQUE ("LB_TYPE_CLIENT"),
	CONSTRAINT "TB_TYPE_CLIENT_PKEY" PRIMARY KEY("CD_TYPE_CLIENT")
);


----------------------------------------------------------------------------
----------------------- Table N°2 : "OPE"."TB_CLIENT" ----------------------
----------------------------------------------------------------------------
-- Création des ENUMs pour la civilité
-- DROP TYPE IF EXISTS "CIVILITE" ;										
CREATE TYPE "CIVILITE"	AS ENUM ('Mlle', 'Mme', 'Mr', 'SARL', 'SA');

-- Script de création de la table	
-- DROP TABLE IF EXISTS "TB_CLIENT" CASCADE ;
CREATE TABLE "TB_CLIENT" 
(
	"ID_CLIENT" 		VARCHAR(20)  NOT NULL,
	"LB_CIVILITE" 		"CIVILITE"   NOT NULL,
	"LB_NOM_CLIENT" 	VARCHAR(100) NOT NULL,
	"LB_PREN_CLIENT" 	VARCHAR(100) ,
	"LB_TEL_CLIENT" 	VARCHAR(20)  ,
	"LB_EMAIL_CLIENT"	VARCHAR(50)  NOT NULL,
	"LB_ADRESSE_CLIENT" VARCHAR(100) NOT NULL,
	"CD_POSTAL_CLIENT" 	VARCHAR(100) ,
	"LB_VILLE_CLIENT" 	VARCHAR(100) NOT NULL,
	"LB_PAYS_CLIENT" 	VARCHAR(100) NOT NULL,
	"CD_TYPE_CLIENT" 	VARCHAR(10)  NOT NULL,
	"NB_ECHEANCE" 		INTEGER 	 NOT NULL,
	CONSTRAINT "TB_CLIENT_PKEY" PRIMARY KEY("ID_CLIENT"),

	CONSTRAINT "TB_TYPE_CLIENT_FKEY" FOREIGN KEY("CD_TYPE_CLIENT") 
		REFERENCES "TB_TYPE_CLIENT"("CD_TYPE_CLIENT")
);


----------------------------------------------------------------------------
-------------------- Table N°3 : "OPE"."TB_PRESTATION" ---------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_PRESTATION" CASCADE ;
CREATE TABLE "TB_PRESTATION" 
(
	"CD_PRESTATION" 		VARCHAR(10) NOT NULL,
	"LB_PRESTATION" 		VARCHAR(100) NOT NULL,
	"NB_PRIX_UNITAIRE"		NUMERIC NOT NULL,
	"NB_TAUX_TVA"			NUMERIC NOT NULL,
	UNIQUE ("LB_PRESTATION"),
	CONSTRAINT "TB_PRESTATION_PKEY" PRIMARY KEY("CD_PRESTATION")
);


----------------------------------------------------------------------------
--------------------- Table N°4 : "OPE"."TB_DEVIS" -------------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_DEVIS" CASCADE;
CREATE TABLE "TB_DEVIS" 
(
	"ID_DEVIS" 			VARCHAR(10) NOT NULL,
	"DT_DEVIS" 			TIMESTAMP WITH TIME ZONE NOT NULL,
	"ID_CLIENT" 		VARCHAR(20)  NOT NULL,

	CONSTRAINT "TB_DEVIS_PKEY" PRIMARY KEY("ID_DEVIS"),	

	CONSTRAINT "TB_CLIENT_FKEY" FOREIGN KEY("ID_CLIENT") 
		REFERENCES "TB_CLIENT"("ID_CLIENT")
);


----------------------------------------------------------------------------
----------------- Table N°5 : "OPE"."TB_DETAIL_DEVIS" ----------------------
----------------------------------------------------------------------------
										
-- DROP TABLE IF EXISTS "TB_DETAIL_DEVIS" CASCADE;		
CREATE TABLE "TB_DETAIL_DEVIS" 
(
	"ID_DEVIS" 			VARCHAR(10) NOT NULL,
	"CD_PRESTATION" 	VARCHAR(10) NOT NULL,
	"NB_QUANTITE" 		NUMERIC NOT NULL,
	"NB_PRIX_HT" 		NUMERIC NOT NULL,
	"NB_PRIX_TTC" 		NUMERIC NOT NULL,	

	CONSTRAINT "TB_DETAIL_DEVIS_PKEY" PRIMARY KEY("ID_DEVIS", "CD_PRESTATION"),

	CONSTRAINT "TB_DEVIS_FKEY" FOREIGN KEY("ID_DEVIS")
		REFERENCES "TB_DEVIS"("ID_DEVIS"),

	CONSTRAINT "TB_PRESTATION_FKEY" FOREIGN KEY("CD_PRESTATION") 
		REFERENCES "TB_PRESTATION"("CD_PRESTATION")	
);										
	
										
----------------------------------------------------------------------------
---------------------- Table N°6 : "OPE"."TB_FACTURE" ----------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_FACTURE" CASCADE;
CREATE TABLE "TB_FACTURE" 
(
	"ID_FACTURE" 		VARCHAR(10) NOT NULL,
	"DT_FACTURE" 		TIMESTAMP WITH TIME ZONE NOT NULL,
	"ID_CLIENT" 		VARCHAR(20) NOT NULL,
	"ID_DEVIS" 			VARCHAR(10) ,

	CONSTRAINT "TB_FACTURE_PKEY" PRIMARY KEY("ID_FACTURE"),	

	CONSTRAINT "TB_CLIENT_FKEY" FOREIGN KEY("ID_CLIENT") 
		REFERENCES "TB_CLIENT"("ID_CLIENT"), 

	CONSTRAINT "TB_DEVIS_FKEY" FOREIGN KEY("ID_DEVIS") 
		REFERENCES "TB_DEVIS"("ID_DEVIS")
);


----------------------------------------------------------------------------
----------------- Table N°7 : "OPE"."TB_DETAIL_FACTURE" --------------------
----------------------------------------------------------------------------
										
-- DROP TABLE IF EXISTS "TB_DETAIL_FACTURE" CASCADE;		
CREATE TABLE "TB_DETAIL_FACTURE" 
(
	"ID_FACTURE" 			VARCHAR(10) NOT NULL,
	"CD_PRESTATION" 		VARCHAR(10) NOT NULL,
	"NB_QUANTITE_FACTURE" 	NUMERIC NOT NULL,
	"NB_PRIX_HT" 			NUMERIC NOT NULL,
	"NB_PRIX_TTC" 			NUMERIC NOT NULL,	

	CONSTRAINT "TB_DETAIL_FACTURE_PKEY" PRIMARY KEY("ID_FACTURE", "CD_PRESTATION" ),

	CONSTRAINT "TB_FACTURE_FKEY" FOREIGN KEY("ID_FACTURE") 
		REFERENCES "TB_FACTURE"("ID_FACTURE"),

	CONSTRAINT "TB_PRESTATION_FKEY" FOREIGN KEY("CD_PRESTATION") 
		REFERENCES "TB_PRESTATION"("CD_PRESTATION")	
);


----------------------------------------------------------------------------
------------------ Table N°8 : "OPE"."TB_TYPE_REGLEMENT" -------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_TYPE_REGLEMENT" CASCADE ;
CREATE TABLE "TB_TYPE_REGLEMENT" 
(
	"CD_TYPE_REGLEMENT" 		VARCHAR(10) NOT NULL,
	"LB_TYPE_REGLEMENT" 		VARCHAR(50) NOT NULL,
	UNIQUE ("LB_TYPE_REGLEMENT"),
	CONSTRAINT "TB_TYPE_REGLEMENT_PKEY" PRIMARY KEY("CD_TYPE_REGLEMENT")
);


----------------------------------------------------------------------------
-------------------- Table N°9 : "OPE"."TB_REGLEMENT" ----------------------
----------------------------------------------------------------------------

-- DROP TABLE IF EXISTS "TB_REGLEMENT" CASCADE;
CREATE TABLE "TB_REGLEMENT" 
(
	"ID_REGLEMENT" 		VARCHAR(10) NOT NULL,
	"DT_REGLEMENT" 		TIMESTAMP WITH TIME ZONE NOT NULL,
	"CD_TYPE_REGLEMENT" VARCHAR(10) NOT NULL,

	CONSTRAINT "TB_REGLEMENT_PKEY" PRIMARY KEY("ID_REGLEMENT"),	

	CONSTRAINT "TB_TYPE_REGLEMENT_FKEY" FOREIGN KEY("CD_TYPE_REGLEMENT") 
		REFERENCES "TB_TYPE_REGLEMENT"("CD_TYPE_REGLEMENT")
);


----------------------------------------------------------------------------
---------------- Table N°10 : "OPE"."TB_DETAIL_REGLEMENT" ------------------
----------------------------------------------------------------------------
										
-- DROP TABLE IF EXISTS "TB_DETAIL_REGLEMENT";		
CREATE TABLE "TB_DETAIL_REGLEMENT" 
(
	"ID_REGLEMENT" 			VARCHAR(10) NOT NULL,
	"ID_FACTURE" 			VARCHAR(10) NOT NULL,
	"NB_MT_REGLEMENT" 		NUMERIC NOT NULL,

	CONSTRAINT "TB_DETAIL_REGLEMENT_PKEY" PRIMARY KEY("ID_REGLEMENT", "ID_FACTURE"),

	CONSTRAINT "TB_REGLEMENT_FKEY" FOREIGN KEY("ID_REGLEMENT") 
		REFERENCES "TB_REGLEMENT"("ID_REGLEMENT"),

	CONSTRAINT "TB_FACTURE_FKEY" FOREIGN KEY("ID_FACTURE") 
		REFERENCES "TB_FACTURE"("ID_FACTURE")
);