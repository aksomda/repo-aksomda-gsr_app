-- recipient_login NULL = message adressé à "l'administration" (tout admin
-- gsr_app peut répondre en ciblant le login de l'expéditeur d'origine).
-- Pas de FOREIGN KEY vers `users` (MyISAM) : intégrité vérifiée côté
-- application.
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_login VARCHAR(10) NOT NULL,
  recipient_login VARCHAR(10) NULL,
  content TEXT NOT NULL,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_messages_sender (sender_login),
  INDEX idx_messages_recipient (recipient_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
