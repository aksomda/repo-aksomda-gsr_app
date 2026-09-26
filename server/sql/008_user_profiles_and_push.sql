-- Photo de profil (MySQL = stockage principal, voir profileController.js)
-- et jetons FCM pour les notifications push. Tables propres à gsr_app, comme
-- account_registrations : pas de FOREIGN KEY vers `users` (MyISAM, sans
-- support réel des clés étrangères), intégrité vérifiée côté application.

CREATE TABLE IF NOT EXISTS user_profiles (
  login VARCHAR(10) PRIMARY KEY,
  photo_blob LONGBLOB NULL,
  photo_content_type VARCHAR(100) NULL,
  photo_size INT NULL,
  photo_updated_at DATETIME NULL,
  -- Miroir Firebase Storage de photo_blob : best effort, reste NULL tant que
  -- Firebase n'est pas configuré ou si la synchronisation échoue.
  firebase_photo_url VARCHAR(500) NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Un utilisateur peut avoir plusieurs jetons (plusieurs appareils) ; un
-- jeton donné appartient à un seul appareil, donc à un seul utilisateur à la
-- fois (ré-attribué à la reconnexion sous un autre compte sur le même
-- appareil).
CREATE TABLE IF NOT EXISTS fcm_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_login VARCHAR(10) NOT NULL,
  token VARCHAR(255) NOT NULL,
  platform VARCHAR(20) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_fcm_token (token),
  INDEX idx_fcm_user (user_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
