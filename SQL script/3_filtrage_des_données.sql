----------------------------------------------------------------------------
-------------- PostgreSQL : Filtrage des données  --------------
--- Fonction de base SQL : SELECT, FROM, DISTINCT, LIMIT, AS, WHERE, IN ----
----------------------------------------------------------------------------

-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";

--- 1/ Afficher la liste des clients n'ayant pas de numéro de téléphone
--- Première solution
SELECT *
FROM "TB_CLIENT"
WHERE "LB_TEL_CLIENT" IS NULL;


--- 2/ Afficher l'identifiant, le nom et prénoms des clients présents dans les pays France ou Canada
SELECT "ID_CLIENT" AS "Identifiant Client", "LB_NOM_CLIENT" AS "Nom Client",
       "LB_PREN_CLIENT" AS "Prénoms Client", "LB_PAYS_CLIENT" AS "Pays Client"
FROM "TB_CLIENT"
WHERE "LB_PAYS_CLIENT" IN ('France', 'Canada');

--- 3/ Afficher la liste des factures du client dont l'identifiant client est 'AB-100151402'
SELECT *
FROM "TB_FACTURE"
WHERE "ID_CLIENT" = 'AB-100151402';

--- 4/ Afficher la liste des prestations dont le prix unitaire est supérieur à 2000
SELECT *
FROM "TB_PRESTATION"
WHERE "NB_PRIX_UNITAIRE" > 2000;

--- 5/ Afficher la liste des codes et libellés des prestations ayant un taux de TVA égal à 5
SELECT "CD_PRESTATION" AS "Code", "LB_PRESTATION" AS "Libellé"
FROM "TB_PRESTATION"
WHERE "NB_TAUX_TVA" = 5;


--- 6/ Afficher le détail des factures de la prestation dont le code prestation est 'PS0001' 
SELECT "ID_FACTURE" AS "Identifiant Facture", "NB_QUANTITE_FACTURE" AS "Qtité Facturée",
		"NB_PRIX_HT" AS "Prix HT", "NB_PRIX_TTC" AS "Prix TTC"
FROM "TB_DETAIL_FACTURE"
WHERE "CD_PRESTATION" ='PS0001';