-- Pas de FOREIGN KEY vers `room`/`users` (tables MyISAM, sans support réel
-- des clés étrangères) : intégrité vérifiée côté application, index
-- classiques pour les performances de lecture.
CREATE TABLE IF NOT EXISTS reservations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL,
  user_login VARCHAR(10) NOT NULL,
  meeting_subject VARCHAR(255) NOT NULL,
  organizing_structure VARCHAR(255) NOT NULL,
  date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status ENUM('en_attente', 'validee', 'rejetee') NOT NULL DEFAULT 'en_attente',
  rejection_reason VARCHAR(255) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_reservations_room (room_id),
  INDEX idx_reservations_user (user_login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
