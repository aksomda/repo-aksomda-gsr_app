-- Pas de FOREIGN KEY vers `users` (MyISAM) : intégrité vérifiée côté
-- application.
CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_login VARCHAR(10) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(500) NOT NULL,
  type VARCHAR(50) NOT NULL,
  reference_id INT NULL,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_notifications_user (user_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
