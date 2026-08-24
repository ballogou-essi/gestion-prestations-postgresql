----------------------------------------------------------------------------
--------------- PostgreSQL  : Jointure de tables  ---------------
--- Fonction de base SQL : SELECT, FROM, DISTINCT, LIMIT, AS, WHERE, IN ----
------ INNER JOIN, LEFT OUTER JOIN, LEFT RIGHT JOIN, FULL OUTER JOIN -------
----------------------------------------------------------------------------
-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";

--- 1/ Afficher le montant TTC des factures par client 
--- (Identifiant client, Nom Client, Prénom Client, Montant TTC)
--- Triez le résultat par ordre décroissant de montant TTC
WITH "MT_FACTURE_CLIENT" AS 
(
	SELECT "ID_CLIENT", SUM("NB_PRIX_HT"*"NB_QUANTITE_FACTURE") AS "Montant HT", 
			SUM("NB_PRIX_TTC"*"NB_QUANTITE_FACTURE") AS "Montant TTC"
	FROM "TB_DETAIL_FACTURE" DF
		INNER JOIN "TB_FACTURE" F 
			ON DF."ID_FACTURE" = F."ID_FACTURE"
	GROUP BY "ID_CLIENT"
)
SELECT FC."ID_CLIENT" AS "Identifiant Client", 
	"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
	"Montant HT", "Montant TTC"
FROM "MT_FACTURE_CLIENT" FC
	INNER JOIN "TB_CLIENT" C
		ON C."ID_CLIENT" = FC."ID_CLIENT"
ORDER BY "Montant TTC" DESC;


--- 2/ Afficher la liste des clients à qui nous avons facturé plus 100000 de prestations au cours de l'année 2023
---	 (Triez le résultat par ordre croissant de montant TTC
---	 Afficher les colonnes Identifiant client, Nom Client, Prénom Client, Montant TTC)

WITH "MT_FACTURE_CLIENT" AS 
(
	SELECT "ID_CLIENT",
			SUM("NB_PRIX_HT"*"NB_QUANTITE_FACTURE") AS "Montant HT", 
			SUM("NB_PRIX_TTC"*"NB_QUANTITE_FACTURE") AS "Montant TTC"
	FROM "TB_DETAIL_FACTURE" DF
		INNER JOIN "TB_FACTURE" F 
			ON DF."ID_FACTURE" = F."ID_FACTURE"
	WHERE EXTRACT(YEAR FROM "DT_FACTURE") = 2023
	GROUP BY "ID_CLIENT"
	HAVING SUM("NB_PRIX_TTC"*"NB_QUANTITE_FACTURE")>100000
)
SELECT FC."ID_CLIENT" AS "Identifiant Client", 
	"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
	"Montant HT", "Montant TTC"
FROM "MT_FACTURE_CLIENT" FC
	INNER JOIN "TB_CLIENT" C
		ON C."ID_CLIENT" = FC."ID_CLIENT"
ORDER BY "Montant TTC" DESC;


--- 3/ Afficher la dernière date de facturation par client
--- Triez le résultat par ordre croissant de date
WITH "DERNIERE_DATE_CLIENT" AS 
(
	SELECT "ID_CLIENT", MAX("DT_FACTURE") AS "Dernière date de commande"
	FROM  "TB_FACTURE"
	GROUP BY "ID_CLIENT"
)
SELECT FC."ID_CLIENT" AS "Identifiant Client", 
	"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
	"Dernière date de commande"
FROM "DERNIERE_DATE_CLIENT" FC
	INNER JOIN "TB_CLIENT" C
		ON C."ID_CLIENT" = FC."ID_CLIENT"
ORDER BY "Dernière date de commande" ASC;


--- 4/ Calculer le delai d'inactivité pour chaque client
--- (Delai d'inactivité = Date du jour - Dernière date de facturation)
WITH "DERNIERE_DATE_CLIENT" AS 
(
	SELECT "ID_CLIENT", MAX("DT_FACTURE") AS "Dernière date de commande"
	FROM  "TB_FACTURE"
	GROUP BY "ID_CLIENT"
)
SELECT FC."ID_CLIENT" AS "Identifiant Client", 
	"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
	"Dernière date de commande"::Date, CURRENT_DATE, 
	CURRENT_DATE-"Dernière date de commande"::Date AS "Delai d'inactivité"
FROM "DERNIERE_DATE_CLIENT" FC
	INNER JOIN "TB_CLIENT" C
		ON C."ID_CLIENT" = FC."ID_CLIENT"
WHERE "Dernière date de commande"::Date<=CURRENT_DATE
ORDER BY "Dernière date de commande" DESC;	

--- 5/ Définir une règle selon le délai d'inactivité : 
---		Si le délai d'incactivité est supérieur à 90 jours Alors le client est inactif 
---		et dans le cas contraire 
---		le client est actif. 
---		(Les colonnes à affichier : 
---		Identifiant client, Nom Client, Prénom Client, Nombre de jours d'inactivité, Actif/Inactifs)

WITH "DERNIERE_DATE_CLIENT" AS 
(
	SELECT "ID_CLIENT", MAX("DT_FACTURE") AS "Dernière date de commande"
	FROM  "TB_FACTURE"
	GROUP BY "ID_CLIENT"
)
SELECT FC."ID_CLIENT" AS "Identifiant Client", 
	"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
	"Dernière date de commande"::Date, CURRENT_DATE, 
	CURRENT_DATE-"Dernière date de commande"::Date AS "Nombre de jours d'inactivité",
	CASE WHEN CURRENT_DATE-"Dernière date de commande"::Date <= 90 THEN 'Client Actif'
		 ELSE 'Client Inactif'
	END "Actif/Inactifs"
FROM "DERNIERE_DATE_CLIENT" FC
	INNER JOIN "TB_CLIENT" C
		ON C."ID_CLIENT" = FC."ID_CLIENT"
WHERE "Dernière date de commande"::Date<=CURRENT_DATE
ORDER BY "Dernière date de commande" DESC;	

--- 6/ Compter le nombre de clients actifs et inactifs
WITH "DERNIERE_DATE_CLIENT" AS 
(
	SELECT "ID_CLIENT", MAX("DT_FACTURE") AS "Dernière date de commande"
	FROM  "TB_FACTURE"
	GROUP BY "ID_CLIENT"
),
"DELAI_INACTIVITE_PAR_CLIENT" AS
(
	SELECT FC."ID_CLIENT" AS "Identifiant Client", 
		"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
		"Dernière date de commande"::Date, CURRENT_DATE, 
		CURRENT_DATE-"Dernière date de commande"::Date AS "Nombre de jours d'inactivité",
		CASE WHEN CURRENT_DATE-"Dernière date de commande"::Date <= 90 THEN 'Client Actif'
			 ELSE 'Client Inactif'
		END "Actif/Inactifs"
	FROM "DERNIERE_DATE_CLIENT" FC
		INNER JOIN "TB_CLIENT" C
			ON C."ID_CLIENT" = FC."ID_CLIENT"
	WHERE "Dernière date de commande"::Date<=CURRENT_DATE
	ORDER BY "Dernière date de commande" DESC
)
SELECT "Actif/Inactifs", COUNT(1)
FROM "DELAI_INACTIVITE_PAR_CLIENT" 
GROUP BY "Actif/Inactifs";

/*
	7/ Afficher le montant total des règlements de facture pour chaque client et par année
*/
WITH "MT_FACTURE_REGLE" AS
(
	SELECT "ID_FACTURE", "DT_REGLEMENT", "NB_MT_REGLEMENT"	
	FROM "TB_REGLEMENT" R
		INNER JOIN "TB_DETAIL_REGLEMENT" DR 
			ON R."ID_REGLEMENT" = DR."ID_REGLEMENT"
), 
"CLIENT_FACTURE_REGLE" AS
(
	SELECT F."ID_FACTURE", "ID_CLIENT", "DT_REGLEMENT", "NB_MT_REGLEMENT" 
	FROM "TB_FACTURE" F
		INNER JOIN "MT_FACTURE_REGLE" MF
			ON F."ID_FACTURE" = MF."ID_FACTURE"
), 
"CLIENT_MT_REGLE_PAR_ANNEE" AS
(
	SELECT CFR."ID_CLIENT" AS "Identifiant Client", 
			"LB_NOM_CLIENT" AS "Nom Client" , "LB_PREN_CLIENT" AS "Prénom Client", 
			EXTRACT(YEAR FROM "DT_REGLEMENT") AS "Année", 
			SUM("NB_MT_REGLEMENT") AS "Montant Réglé"
	FROM "CLIENT_FACTURE_REGLE" CFR
		INNER JOIN "TB_CLIENT" C
			ON C."ID_CLIENT" = CFR."ID_CLIENT"
	GROUP BY CFR."ID_CLIENT" , "LB_NOM_CLIENT" , "LB_PREN_CLIENT" , 
			EXTRACT(YEAR FROM "DT_REGLEMENT")
	ORDER BY SUM("NB_MT_REGLEMENT") DESC
)
SELECT "Identifiant Client", "Nom Client", "Prénom Client", "Montant Réglé",
SUM("Montant Réglé") FILTER (WHERE "Année" = 2023) AS "2023",
	SUM("Montant Réglé") FILTER (WHERE "Année" = 2024) AS "2024"
FROM "CLIENT_MT_REGLE_PAR_ANNEE"
		GROUP BY 1, 2, 3, 4
		ORDER BY 4 DESC;