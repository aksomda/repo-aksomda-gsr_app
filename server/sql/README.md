# Migrations SQL

`users` et `ref_structure` sont des tables **déjà existantes**, appartenant à un
autre système (intranet DGI) : ne jamais y ajouter de colonne, ni les
renommer. Ces migrations ne font que lire ces deux tables ou écrire dans
leurs colonnes déjà existantes.

`room` et `category_room` existent déjà elles aussi (schéma différent d'une
salle de réunion générique : `region`/`province`/`city`/`status` en INT,
suppression logique via `del`) mais peuvent être librement complétées.

Convention `room.status` (aucune convention préexistante, définie ici) :
1=disponible, 2=réservé, 3=en réfection, 4=dégradé, 5=en construction.

`room.region`/`province`/`city` (INT) sont dépréciées côté gsr_app et laissées
à 0. La localisation saisie dans le formulaire d'une salle est stockée dans
`room.region_name`/`province_name`/`city_name`/`location` (texte, migration
007) ; la structure DGI de rattachement est `room.structure_code`.

`user_profiles` (photo de profil, migration 008) stocke la photo en `LONGBLOB` :
MySQL est le stockage principal, Firebase Storage n'en reçoit qu'un miroir
best-effort (`firebase_photo_url`, voir `services/firebase.js`). `fcm_tokens`
(migration 008) mémorise les jetons de notification push par appareil.

Exécuter les fichiers dans l'ordre numérique.
