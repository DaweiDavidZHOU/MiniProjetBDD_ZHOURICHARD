USE projet_alcool;

ALTER TABLE Boisson
ADD CONSTRAINT chk_degre_alcool
CHECK (boi_degre_alcool > 0 AND boi_degre_alcool < 100);

ALTER TABLE Boisson
ADD CONSTRAINT chk_millesime
CHECK (boi_millesime IS NULL OR boi_millesime BETWEEN 1000 AND 2030);

ALTER TABLE Boisson
ADD CONSTRAINT chk_vieillissement
CHECK (boi_vieillissement_mois IS NULL OR boi_vieillissement_mois >= 0);

ALTER TABLE Consommation
ADD CONSTRAINT chk_volume_positif
CHECK (con_volume_par_habitant >= 0);

ALTER TABLE Consommation
ADD CONSTRAINT chk_annee_conso
CHECK (con_annee BETWEEN 1000 AND 2030);

ALTER TABLE Consommation
ADD CONSTRAINT chk_statut
CHECK (statut IN ('provisoire', 'définitive'));

ALTER TABLE Reglementation
ADD CONSTRAINT chk_age_minimum
CHECK (regl_age_minimum_achat BETWEEN 0 AND 25);

ALTER TABLE Reglementation
ADD CONSTRAINT chk_taux_taxation
CHECK (regl_taux_taxation BETWEEN 0 AND 100);

ALTER TABLE Reglementation
ADD CONSTRAINT chk_date_regl
CHECK (regl_date_entree_vigueur BETWEEN '1000-01-01' AND '2030-12-31');

ALTER TABLE EstBaseDe
ADD CONSTRAINT chk_proportion
CHECK (proportion BETWEEN 0.01 AND 100.00);

ALTER TABLE Producteur
ADD CONSTRAINT chk_annee_creation
CHECK (pro_annee_creation IS NULL OR pro_annee_creation BETWEEN 1000 AND 2030);

ALTER TABLE Pays
ADD CONSTRAINT chk_population
CHECK (pay_population > 0);
