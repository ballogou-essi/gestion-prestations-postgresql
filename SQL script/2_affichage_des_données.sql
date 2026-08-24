----------------------------------------------------------------------------
-------------- PostgreSQL : Affichage des données  -------------
--------- Fonction de base SQL : SELECT, FROM, DISTINCT, LIMIT, AS ---------
----------------------------------------------------------------------------

-- Définir le schéma à utiliser
SET SEARCH_PATH = "OPE";

--- 1/ Afficher la liste des clients (sélectionner toutes les colonnes)
SELECT *
FROM   "TB_CLIENT";

--- 2/ Afficher la liste des clients limitée à 1000 enregistrements (sélectionner toutes les colonnes)
SELECT *
FROM   "TB_CLIENT"
LIMIT  1000;

--- 3/ Afficher l'identifiant, le nom et prénoms des clients
SELECT "ID_CLIENT" AS "Identifiant Client", "LB_NOM_CLIENT" "Nom Client", "LB_PREN_CLIENT" "Prénoms Client"
FROM   "TB_CLIENT";

--- 4/ Afficher la liste distincte des pays des clients
SELECT DISTINCT "LB_PAYS_CLIENT" AS "Pays"
FROM   "TB_CLIENT";

--- 5/ Afficher la liste des prestations (sélectionner toutes les colonnes)
SELECT *
FROM "TB_PRESTATION";

--- 6/ Afficher la liste des prestations limitée à 50 enregistrements (sélectionner toutes les colonnes)
SELECT *
FROM "TB_PRESTATION"
LIMIT 50;

--- 7/ Afficher la liste des codes et libellés des prestations
SELECT "CD_PRESTATION" AS "Code Prestation", "LB_PRESTATION" "Libellé Prestation"
FROM "TB_PRESTATION";

--- 8/ Afficher la liste distincte des prestations facturées (Afficher que le code de la prestation)
SELECT DISTINCT "CD_PRESTATION" AS "Code Prestation"
FROM "TB_DETAIL_FACTURE";







