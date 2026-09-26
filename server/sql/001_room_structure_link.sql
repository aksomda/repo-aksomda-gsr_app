-- Rattache une salle à une structure DGI (ref_structure), qui porte déjà
-- la localité (LOCALITE_CDI) : remplace l'idée d'une hiérarchie
-- région/province/ville propre à gsr_app.

ALTER TABLE room
  ADD COLUMN structure_code VARCHAR(10) NULL,
  ADD FOREIGN KEY (structure_code) REFERENCES ref_structure(CODE_CDI);
