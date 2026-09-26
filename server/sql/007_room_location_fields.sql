-- Colonnes texte pour la localisation saisie dans le formulaire d'une salle.
-- room.region/province/city sont des INT hérités (dépréciés, remplis à 0) :
-- on ne les réutilise pas, on ajoute des colonnes dédiées.
ALTER TABLE room
  ADD COLUMN region_name VARCHAR(255) NULL,
  ADD COLUMN province_name VARCHAR(255) NULL,
  ADD COLUMN city_name VARCHAR(255) NULL,
  ADD COLUMN location VARCHAR(255) NULL;
