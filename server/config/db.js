const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'dbgsr',
  password: 'r6TKIW/WiC)XTGh/', // Ton mot de passe MySQL
  database: 'dbgsr',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;