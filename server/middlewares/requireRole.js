// À utiliser après `authenticate` : requireRole('admin') refuse la requête
// si req.user.role ne correspond à aucun des rôles autorisés.
module.exports = function requireRole(...allowedRoles) {
  return function (req, res, next) {
    if (!req.user || !allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ success: false, error: "Accès refusé : privilèges insuffisants." });
    }
    next();
  };
};
