-- Pas de FOREIGN KEY vers `users` (MyISAM) : intégrité vérifiée côté
-- application.
CREATE TABLE IF NOT EXISTS activity_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_login VARCHAR(10) NULL,
  action VARCHAR(100) NOT NULL,
  details JSON NULL,
  ip_address VARCHAR(45) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_activity_logs_user (user_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
