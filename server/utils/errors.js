// Le détail d'une erreur interne (message SQL, chemin de fichier, pile
// d'appel...) ne doit jamais atteindre le client : il est journalisé côté
// serveur, et un message générique est renvoyé à la place.
function sendServerError(res, error, publicMessage = 'Une erreur interne est survenue.') {
  console.error(error);
  res.status(500).json({ success: false, error: publicMessage });
}

module.exports = { sendServerError };
