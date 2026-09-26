require('dotenv').config();
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'dbgsr',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'dbgsr',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  // Renvoie les colonnes DATE/DATETIME/TIMESTAMP sous forme de chaînes
  // (ex: "2026-09-20") plutôt que des objets Date convertis selon le fuseau
  // du serveur Node, pour éviter tout décalage avec la date envoyée par le
  // client lors de la vérification de disponibilité d'une salle.
  dateStrings: true,
});

module.exports = pool;
