----------------------------------------------------------------------------
--------------- PostgreSQL : Jointure de tables  ---------------
--- Fonction de base SQL : SELECT, FROM, DISTINCT, LIMIT, AS, WHERE, IN ----
------ INNER JOIN, LEFT OUTER JOIN, LEFT RIGHT JOIN, FULL OUTER JOIN -------
----------------------------------------------------------------------------

-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";

--- 1/ Afficher l'identifiant, le nom et prénoms des clients présents dans les pays France ou Canada 
---	  et ayant été facturé au moins une fois

SELECT DISTINCT F."ID_CLIENT" AS "Identifiant Client", "LB_NOM_CLIENT" AS "Nom Client",
	    "LB_PREN_CLIENT" AS "Prénom Client", "LB_PAYS_CLIENT" AS "Pays Client"
		
FROM "TB_FACTURE" AS F 
		INNER JOIN "TB_CLIENT" C 
			ON F."ID_CLIENT" = C."ID_CLIENT"
	
WHERE "LB_PAYS_CLIENT" IN ('France', 'Canada')
ORDER BY  F."ID_CLIENT";



--- 2/ Afficher la liste des factures n'ayant pas été réglé
---	 (Afficher toutes les colonnes de la table facture et renommer chacune d'elle)

SELECT F."ID_FACTURE" AS "Identifiant Facture", "DT_FACTURE" AS "Date Facture",
		"ID_CLIENT" AS "Identifiant Client", "ID_DEVIS" AS "Identfiant Devis"
	
FROM "TB_FACTURE" F
		LEFT OUTER JOIN "TB_DETAIL_REGLEMENT" DR
			ON F."ID_FACTURE" = DR."ID_FACTURE"
	
WHERE DR."ID_FACTURE" IS NULL;

--- 3/ Afficher la liste des factures non réglée du client Alex Migaa (Nom = Alex, prénom = Migaa)
---	 (Afficher toutes les colonnes de la table facture et renommer chacune d'elle)

SELECT F."ID_FACTURE" AS "Identifiant Facture", "DT_FACTURE" AS "Date Facture",
		F."ID_CLIENT" AS "Identifiant Client", "ID_DEVIS" AS "Identfiant Devis"
	
FROM "TB_FACTURE" F
		LEFT OUTER JOIN "TB_DETAIL_REGLEMENT" DR
			ON F."ID_FACTURE" = DR."ID_FACTURE"

		INNER JOIN "TB_CLIENT" C
			ON F."ID_CLIENT" = C."ID_CLIENT"
	
WHERE DR."ID_FACTURE" IS NULL
	AND "LB_NOM_CLIENT" = 'Alex' 
	AND "LB_PREN_CLIENT" = 'Migaa';


--- 4/ Afficher la liste des devis n'ayant jamais fait l'objet d'une facturation
SELECT D."ID_DEVIS" AS "Identiiant Devis", "DT_DEVIS" AS "Date Devis", D."ID_CLIENT" AS "Identifiant Client"
FROM "TB_DEVIS" D
	LEFT OUTER JOIN "TB_FACTURE" F
		ON D."ID_DEVIS" = F."ID_DEVIS"
WHERE F."ID_DEVIS" IS NULL;

--- 5/ Afficher la liste des devis ayant fait l'objet d'une facturation
SELECT D."ID_DEVIS" AS "Identiiant Devis", "DT_DEVIS" AS "Date Devis", D."ID_CLIENT" AS "Identifiant Client"
FROM "TB_DEVIS" D
	LEFT OUTER JOIN "TB_FACTURE" F
		ON D."ID_DEVIS" = F."ID_DEVIS"
WHERE F."ID_DEVIS" IS NOT NULL;

--- 6/ Afficher la liste des factures d'un devis mais n'ayant pas été réglé pour le client Alex Bampara
SELECT F."ID_FACTURE" AS "Identifiant Facture", "DT_FACTURE" AS "Dt Facture", F."ID_CLIENT" AS "Identifiant Client",
		F."ID_DEVIS" AS "Identifiant Devis"

FROM "TB_FACTURE" F
		INNER JOIN "TB_CLIENT" C 
			ON F."ID_CLIENT" = C."ID_CLIENT"

		LEFT OUTER JOIN "TB_DETAIL_REGLEMENT" DR
			ON F."ID_FACTURE" = DR."ID_FACTURE"

WHERE "ID_DEVIS" IS NOT NULL
	AND "LB_NOM_CLIENT" = 'Alex'
	AND "LB_PREN_CLIENT" = 'Bampara'
	AND DR."ID_FACTURE" IS NULL;