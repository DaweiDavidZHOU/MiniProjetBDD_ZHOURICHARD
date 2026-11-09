-- Initialisation
DROP DATABASE IF EXISTS projet_alcool;
CREATE DATABASE projet_alcool
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;
USE projet_alcool;

-- Création table
CREATE TABLE Categorie (
   cat_id INT,
   cat_nom VARCHAR(40) NOT NULL,
   PRIMARY KEY(cat_id)
);

CREATE TABLE Pays (
   pay_code_iso CHAR(2),
   pay_nom VARCHAR(60) NOT NULL,
   pay_population BIGINT,
   PRIMARY KEY(pay_code_iso)
);

CREATE TABLE SousCategorie (
   cat_id INT,
   scat_id INT,
   scat_nom VARCHAR(40) NOT NULL,
   PRIMARY KEY(cat_id, scat_id),
   FOREIGN KEY(cat_id) REFERENCES Categorie(cat_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE RegionProduction (
   reg_id INT,
   reg_nom VARCHAR(60) NOT NULL,
   pay_code_iso CHAR(2) NOT NULL,
   PRIMARY KEY(reg_id),
   FOREIGN KEY(pay_code_iso) REFERENCES Pays(pay_code_iso)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Appellation (
   app_id INT,
   app_nom_officiel VARCHAR(80) NOT NULL,
   app_type VARCHAR(10),
   reg_id INT NOT NULL,
   PRIMARY KEY(app_id),
   FOREIGN KEY(reg_id) REFERENCES RegionProduction(reg_id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE Producteur (
   pro_id INT,
   pro_raison_sociale VARCHAR(80) NOT NULL,
   pro_annee_creation SMALLINT,
   pay_code_iso CHAR(2) NOT NULL,
   PRIMARY KEY(pro_id),
   FOREIGN KEY(pay_code_iso) REFERENCES Pays(pay_code_iso)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE Reglementation (
   regl_id INT,
   regl_intitule VARCHAR(60) NOT NULL,
   regl_date_entree_vigueur DATE NOT NULL,
   regl_age_minimum_achat SMALLINT,
   regl_taux_taxation DECIMAL(5,2),
   pay_code_iso CHAR(2) NOT NULL,
   PRIMARY KEY(regl_id),
   FOREIGN KEY(pay_code_iso) REFERENCES Pays(pay_code_iso)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE Boisson (
   boi_id INT,
   boi_nom VARCHAR(80) NOT NULL,
   boi_degre_alcool DECIMAL(4,2) NOT NULL,
   boi_description VARCHAR(255),
   boi_millesime SMALLINT,
   boi_vieillissement_mois SMALLINT,
   app_id INT,
   pro_id INT NOT NULL,
   cat_id INT NOT NULL,
   scat_id INT,  -- Seulement scat_id peut être NULL
   
   PRIMARY KEY(boi_id),
   
   FOREIGN KEY(app_id) REFERENCES Appellation(app_id)
      ON DELETE SET NULL
      ON UPDATE CASCADE,
   
   FOREIGN KEY(pro_id) REFERENCES Producteur(pro_id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE,

   FOREIGN KEY(cat_id, scat_id) REFERENCES SousCategorie(cat_id, scat_id)
      ON DELETE RESTRICT 
      ON UPDATE CASCADE,
   
   FOREIGN KEY(cat_id) REFERENCES Categorie(cat_id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE
);

CREATE TABLE Concerne (
   regl_id INT,
   cat_id INT,
   PRIMARY KEY(regl_id, cat_id),
   FOREIGN KEY(regl_id) REFERENCES Reglementation(regl_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
   FOREIGN KEY(cat_id) REFERENCES Categorie(cat_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

CREATE TABLE Consommation (
   cat_id INT,
   boi_id INT,
   pay_code_iso CHAR(2),
   con_annee INT NOT NULL,
   con_volume_par_habitant DECIMAL(15,2),
   source VARCHAR(150),
   statut VARCHAR(20),
   date_maj DATE,
   PRIMARY KEY(cat_id, boi_id, pay_code_iso, con_annee),
   FOREIGN KEY(cat_id) REFERENCES Categorie(cat_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
   FOREIGN KEY(boi_id) REFERENCES Boisson(boi_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
   FOREIGN KEY(pay_code_iso) REFERENCES Pays(pay_code_iso)
      ON DELETE CASCADE
      ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EstBaseDe (
   boi_id_base INT,
   boi_id_derivee INT,
   proportion DECIMAL(5,2),
   PRIMARY KEY(boi_id_base, boi_id_derivee),
   FOREIGN KEY(boi_id_base) REFERENCES Boisson(boi_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,
   FOREIGN KEY(boi_id_derivee) REFERENCES Boisson(boi_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);
