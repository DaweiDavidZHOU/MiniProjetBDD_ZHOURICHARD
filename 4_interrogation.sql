USE projet_alcool;

-- 1. PROJECTIONS, SÉLECTIONS, TRI, MASQUES, IN, BETWEEN 
-- 1.1 Lister les boissons d'une catégorie avec leur degré — sélection + tri
SELECT boi_nom, boi_degre_alcool, boi_millesime
FROM Boisson
WHERE cat_id = (SELECT cat_id FROM Categorie WHERE cat_nom = 'Vin')
ORDER BY boi_degre_alcool DESC;

-- 1.2 Boissons dont le nom contient "Champagne" ou "Cidre" — masque LIKE
SELECT boi_nom, boi_description
FROM Boisson
WHERE boi_nom LIKE '%Champagne%'
   OR boi_nom LIKE '%Cidre%';

-- 1.3 Producteurs implantés en France, Italie, Espagne — IN
SELECT pro_raison_sociale, pro_annee_creation
FROM Producteur
WHERE pay_code_iso IN ('FR', 'IT', 'ES')
ORDER BY pro_raison_sociale;

-- 1.4 Mesures de consommation sur la période 2020–2023 — BETWEEN + DISTINCT
SELECT DISTINCT con_annee, statut, source
FROM Consommation
WHERE con_annee BETWEEN 2020 AND 2023
ORDER BY con_annee DESC;

-- 1.5 Réglementations entrées en vigueur entre 2000 et 2024 — BETWEEN
SELECT regl_intitule, regl_date_entree_vigueur, pay_code_iso
FROM Reglementation
WHERE regl_date_entree_vigueur BETWEEN '2000-01-01' AND '2024-12-31';

-- 2. FONCTIONS D'AGRÉGATION, GROUP BY, HAVING 
-- 2.1 Nombre de boissons et degré moyen par catégorie
SELECT c.cat_nom,
       COUNT(b.boi_id) AS nb_boissons,
       ROUND(AVG(b.boi_degre_alcool), 2) AS degre_moyen
FROM Categorie c
LEFT JOIN Boisson b ON c.cat_id = b.cat_id
GROUP BY c.cat_id, c.cat_nom
HAVING COUNT(b.boi_id) > 0;

-- 2.2 Volume total consommé par pays — classer les pays par volume
SELECT p.pay_nom,
       SUM(co.con_volume_par_habitant) AS volume_total_par_habitant
FROM Consommation co
JOIN Pays p ON co.pay_code_iso = p.pay_code_iso
GROUP BY p.pay_code_iso, p.pay_nom
HAVING SUM(co.con_volume_par_habitant) > 0
ORDER BY volume_total_par_habitant DESC;

-- 2.3 Nombre de producteurs par pays — retenir ceux qui en ont ≥ 2
SELECT p.pay_nom,
       COUNT(DISTINCT pr.pro_id) AS nb_producteurs
FROM Pays p
JOIN Producteur pr ON p.pay_code_iso = pr.pay_code_iso
GROUP BY p.pay_code_iso, p.pay_nom
HAVING COUNT(DISTINCT pr.pro_id) >= 2;

-- 2.4 Volume maximum et minimum consommé par catégorie en 2023
SELECT c.cat_nom,
       MAX(co.con_volume_par_habitant) AS conso_max,
       MIN(co.con_volume_par_habitant) AS conso_min
FROM Consommation co
JOIN Categorie c ON co.cat_id = c.cat_id
WHERE co.con_annee = 2023
GROUP BY c.cat_id, c.cat_nom;

-- 2.5 Nombre de mesures provisoires par pays
SELECT p.pay_nom,
       COUNT(*) AS donnees_provisoires
FROM Consommation co
JOIN Pays p ON co.pay_code_iso = p.pay_code_iso
WHERE co.statut = 'provisoire'
GROUP BY p.pay_code_iso, p.pay_nom
HAVING COUNT(*) > 0;

-- 3. JOINTURES INTERNES, EXTERNES, SIMPLES, MULTIPLES 
-- 3.1 Boissons avec catégorie, sous-catégorie (LEFT JOIN), producteur et pays
SELECT b.boi_nom AS boisson,
       c.cat_nom AS categorie,
       sc.scat_nom AS sous_categorie,
       pr.pro_raison_sociale AS producteur,
       p.pay_nom AS pays_producteur
FROM Boisson b
JOIN Categorie c ON b.cat_id = c.cat_id
LEFT JOIN SousCategorie sc
  ON b.cat_id = sc.cat_id AND b.scat_id = sc.scat_id
JOIN Producteur pr ON b.pro_id = pr.pro_id
JOIN Pays p ON pr.pay_code_iso = p.pay_code_iso;

-- 3.2 Consommation : pays, catégorie, boisson, source — jointure multiple
SELECT p.pay_nom AS pays,
       c.cat_nom AS categorie,
       b.boi_nom AS boisson,
       co.con_volume_par_habitant,
       co.source,
       co.statut
FROM Consommation co
JOIN Pays p ON co.pay_code_iso = p.pay_code_iso
JOIN Categorie c ON co.cat_id = c.cat_id
JOIN Boisson b ON co.boi_id = b.boi_id;

-- 3.3 Réglementation applicable par pays et catégorie — LEFT JOIN
SELECT r.regl_intitule,
       p.pay_nom,
       c.cat_nom AS categorie_concernee,
       r.regl_age_minimum_achat,
       r.regl_taux_taxation
FROM Reglementation r
JOIN Pays p ON r.pay_code_iso = p.pay_code_iso
LEFT JOIN Concerne co ON r.regl_id = co.regl_id
LEFT JOIN Categorie c ON co.cat_id = c.cat_id;

-- 3.4 Appellations, régions et pays — chaîne de jointures
SELECT p.pay_nom,
       r.reg_nom AS region_de_production,
       a.app_nom_officiel AS appellation,
       a.app_type AS label
FROM Pays p
JOIN RegionProduction r ON p.pay_code_iso = r.pay_code_iso
LEFT JOIN Appellation a ON r.reg_id = a.reg_id;

-- 3.5 Composition des produits dérivés — auto-jointure
SELECT base.boi_nom AS boisson_de_base,
       der.boi_nom AS produit_obtenu,
       eb.proportion AS proportion_pct
FROM EstBaseDe eb
JOIN Boisson base ON eb.boi_id_base = base.boi_id
JOIN Boisson der ON eb.boi_id_derivee = der.boi_id;

-- 4. REQUÊTES IMBRIQUÉES : IN, EXISTS, ANY, ALL, NOT IN 
-- 4.1 Boissons produites dans un pays européen — IN
SELECT boi_nom
FROM Boisson
WHERE pro_id IN (
    SELECT pro_id FROM Producteur
    WHERE pay_code_iso IN ('FR','DE','IT','ES','BE','CH','AT','PT','NL','GB')
);

-- 4.2 Pays ayant une consommation de bière > 50 L/hab — EXISTS
SELECT DISTINCT p.pay_nom
FROM Pays p
WHERE EXISTS (
    SELECT * FROM Consommation co
    JOIN Categorie c ON co.cat_id = c.cat_id
    WHERE co.pay_code_iso = p.pay_code_iso
      AND c.cat_nom = 'Bière'
      AND co.con_volume_par_habitant > 50
);

-- 4.3 La boisson la plus alcoolisée du référentiel — ALL
SELECT boi_nom, boi_degre_alcool
FROM Boisson
WHERE boi_degre_alcool >= ALL (
    SELECT boi_degre_alcool FROM Boisson
);

-- 4.4 Boissons sans aucune mesure de consommation — NOT IN
SELECT boi_nom
FROM Boisson
WHERE boi_id NOT IN (
    SELECT DISTINCT boi_id FROM Consommation
);

-- 4.5 Pays avec la plus forte consommation de vin en 2023 — IN + sous-requête imbriquée
SELECT p.pay_nom
FROM Pays p
WHERE p.pay_code_iso IN (
    SELECT co.pay_code_iso
    FROM Consommation co
    JOIN Categorie c ON co.cat_id = c.cat_id
    WHERE c.cat_nom = 'Vin'
      AND co.con_annee = 2023
      AND co.con_volume_par_habitant = (
          SELECT MAX(c2_con.con_volume_par_habitant)
          FROM Consommation c2_con
          JOIN Categorie c2_cat ON c2_con.cat_id = c2_cat.cat_id
          WHERE c2_cat.cat_nom = 'Vin' 
            AND c2_con.con_annee = 2023
      )
);

-- 5. CONTRÔLES DE COHÉRENCE — Règles métier du scénario
-- 5.1 Vérifier l'absence de doublon dans les mesures
SELECT pay_code_iso, cat_id, boi_id, con_annee, COUNT(*) AS nb_occurrences
FROM Consommation
GROUP BY pay_code_iso, cat_id, boi_id, con_annee
HAVING COUNT(*) > 1;

-- 5.2 Vérifier qu'aucune boisson n'est sa propre base
SELECT * FROM EstBaseDe
WHERE boi_id_base = boi_id_derivee;

-- 5.3 Vérifier que tous les volumes sont positifs
SELECT COUNT(*) AS volume_negatif_detecte
FROM Consommation
WHERE con_volume_par_habitant < 0;
