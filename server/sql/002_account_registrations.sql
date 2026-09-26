-- "S'inscrire" sur gsr_app = activer l'accès gsr_app pour un agent DGI déjà
-- présent dans `users` (jamais création d'une nouvelle ligne users).
-- Le mot de passe choisi n'est appliqué à users.mdp qu'après confirmation
-- de l'email (voir pending_password_hash) ; l'accès n'est effectif qu'après
-- validation d'un administrateur gsr_app (approved_at), indépendamment de
-- `users.Etat` qui reste piloté par la RH.
--
-- Pas de FOREIGN KEY vers `users` : `users` est en MyISAM (pas de support
-- réel des clés étrangères), l'intégrité référentielle est vérifiée côté
-- application.

CREATE TABLE IF NOT EXISTS account_registrations (
  login VARCHAR(10) PRIMARY KEY,
  pending_password_hash VARCHAR(64) NOT NULL,
  activation_token VARCHAR(255) NOT NULL,
  token_expires_at DATETIME NOT NULL,
  email_verified_at DATETIME NULL,
  approved_at DATETIME NULL,
  approved_by VARCHAR(10) NULL,
  rejected_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
