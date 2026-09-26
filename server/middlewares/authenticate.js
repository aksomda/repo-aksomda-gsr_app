const jwt = require('jsonwebtoken');

// Vérifie le header "Authorization: Bearer <token>" et attache l'utilisateur
// décodé (login, role) à req.user. Toutes les routes protégées passent par ici.
module.exports = function authenticate(req, res, next) {
  const header = req.header('Authorization') || '';
  const [scheme, token] = header.split(' ');

  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json({ success: false, error: 'Authentification requise.' });
  }

  if (!process.env.JWT_SECRET) {
    console.error('JWT_SECRET manquant côté serveur (fichier .env).');
    return res.status(500).json({ success: false, error: 'Configuration serveur invalide.' });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { login: payload.login, role: payload.role };
    next();
  } catch (e) {
    return res.status(401).json({ success: false, error: 'Session invalide ou expirée.' });
  }
};
