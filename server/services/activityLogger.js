// Journalisation transverse (table activity_logs).
//
// - logActivity(pool, {...}) : à appeler explicitement à la fin d'une action
//   métier (login, création de réservation, validation de compte...) pour
//   obtenir un journal lisible avec une action nommée.
// - auditRequests(pool) : middleware filet de sécurité qui journalise TOUTE
//   requête authentifiée (méthode + chemin + statut), pour ne rien manquer
//   même si une route oublie d'appeler logActivity explicitement.
async function logActivity(pool, { login = null, action, details = null, req = null }) {
  try {
    const ip = req ? req.headers['x-forwarded-for'] || req.socket?.remoteAddress || null : null;
    await pool.query(
      'INSERT INTO activity_logs (user_login, action, details, ip_address) VALUES (?, ?, ?, ?)',
      [login, action, details ? JSON.stringify(details) : null, ip]
    );
  } catch (error) {
    console.error("Échec de journalisation d'activité :", error.message);
  }
}

function auditRequests(pool) {
  return function (req, res, next) {
    res.on('finish', () => {
      logActivity(pool, {
        login: req.user ? req.user.login : null,
        action: 'http_request',
        details: { method: req.method, path: req.originalUrl, status: res.statusCode },
        req,
      });
    });
    next();
  };
}

module.exports = { logActivity, auditRequests };
