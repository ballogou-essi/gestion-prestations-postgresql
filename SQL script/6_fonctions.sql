----------------------------------------------------------------------------
--------------- PostgreSQL : Jointure de tables  ---------------
--- Fonction de base SQL : SELECT, FROM, DISTINCT, LIMIT, AS, WHERE, IN ----
------ INNER JOIN, LEFT OUTER JOIN, LEFT RIGHT JOIN, FULL OUTER JOIN -------
----------------------------------------------------------------------------

-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";

--- 1/ Afficher l'identifiant, nom et prénoms des client (Concatener le nom et prénom)

SELECT "ID_CLIENT" AS "Identifiant Client", 
	   "LB_NOM_CLIENT" || ' ' || "LB_PREN_CLIENT" AS "Nom et prénoms Client", 
		CONCAT("LB_NOM_CLIENT", ' ', "LB_PREN_CLIENT") AS "Nom et prénoms Client"
FROM "TB_CLIENT";



--- 2/ Afficher la liste des types de client (Fusionner toutes les lignes en une seule)
SELECT STRING_AGG("CD_TYPE_CLIENT", '|') AS "Code", 
	   STRING_AGG("LB_TYPE_CLIENT", '|') AS "Type de client"
FROM "TB_TYPE_CLIENT";


--- 3/ Concatener toutes les colonnes de la table "TB_TYPE_CLIENT"
SELECT "TB_TYPE_CLIENT"::TEXT, 
		REPLACE(RTRIM(LTRIM("TB_TYPE_CLIENT"::TEXT,'('),')'),',','|')
FROM "TB_TYPE_CLIENT";


--- 4/ Afficher le nombre de clients dont le numéro de téléphone est différent de 0000000000
SELECT COUNT(1) 
FROM   "TB_CLIENT" 
WHERE COALESCE("LB_TEL_CLIENT",'N/A') NOT IN ('0000000000')



--- 5/ Afficher la liste des prestations 
---	   Sélectionner toutes les colonnes. Le libellé de prestation doit être en majuscule
	SELECT "CD_PRESTATION" AS "Code prestation",
		   UPPER("LB_PRESTATION") AS "Libellé prestation",
		   "NB_PRIX_UNITAIRE" AS "Prix unitaire", 
		   "NB_TAUX_TVA" AS "Taux de TVA"
	FROM "TB_PRESTATION";


--- 6/ Afficher la liste des prestations 
/*	   Sélectionner toutes les colonnes.
	   Chaque début de caractère du libellé de prestation doit être en majuscule après un espace*/
SELECT "CD_PRESTATION" AS "Code prestation",
	 INITCAP("LB_PRESTATION") AS "Libellé prestation",
		   "NB_PRIX_UNITAIRE" AS "Prix unitaire", 
		   "NB_TAUX_TVA" AS "Taux de TVA"
FROM "TB_PRESTATION";


--- 7/ Afficher la liste des prestations suivi d'une grille d'apréciation des prix
	/* Si le prix unitaire de la prestation est inférieur à 750 Alors "Faible prestation"
	   Si le prix unitaire de la prestation est inférieur à 1750 Alors "Prestation moyenne"
	   Si le prix unitaire de la prestation est inférieur à 2750 Alors "Prestation interessante"
	   Si aucun des cas cités ci-dessus n'est respecté Alors "Prestation très intéressante"
	*/
SELECT "CD_PRESTATION" AS "Code prestation",
	   "LB_PRESTATION" AS "Libellé prestation",    
       "NB_PRIX_UNITAIRE" AS "Prix unitaire",    
		CASE WHEN "NB_PRIX_UNITAIRE" < 750 THEN 'Faible prestation'
			 WHEN "NB_PRIX_UNITAIRE" < 1750 THEN 'Prestation moyenne'
			 WHEN "NB_PRIX_UNITAIRE" < 2750 THEN 'Prestation interessante'
			 ELSE 'Prestation très intéressante'
		END AS "Appréciation Tarif",
       "NB_TAUX_TVA" AS "Taux de TVA"
FROM "TB_PRESTATION";


--- 8/ Enlever PS du code de la prestation
SELECT REPLACE("CD_PRESTATION",'PS','')::TEXT AS "Code prestation",
		   UPPER("LB_PRESTATION") AS "Libellé prestation",
		   "NB_PRIX_UNITAIRE" AS "Prix unitaire", 
		   "NB_TAUX_TVA" AS "Taux de TVA"
	FROM "TB_PRESTATION";
