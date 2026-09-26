// Vérifications de configuration faites au démarrage : en production, le
// serveur refuse de démarrer avec une configuration de développement.

const WEAK_SECRET_MARKERS = ['change_me', 'dev-only', 'secret', 'password'];

function productionConfigProblems(env = process.env) {
  if (env.NODE_ENV !== 'production') return [];

  const problems = [];
  const secret = env.JWT_SECRET || '';
  if (secret.length < 32 || WEAK_SECRET_MARKERS.some((m) => secret.toLowerCase().includes(m))) {
    problems.push('JWT_SECRET doit être une chaîne aléatoire de 32 caractères minimum (pas la valeur d\'exemple).');
  }
  if (!env.ALLOWED_ORIGIN) {
    problems.push("ALLOWED_ORIGIN doit lister les origines web autorisées (CORS) en production.");
  }
  if (!/^https:\/\//.test(env.APP_BASE_URL || '')) {
    problems.push('APP_BASE_URL doit être une URL https en production (lien d\'activation envoyé par email).');
  }
  return problems;
}

// Origines CORS : liste explicite si fournie ; ouvert en développement ;
// fermé en production tant qu'aucune origine n'est déclarée.
function corsOrigin(env = process.env) {
  if (env.ALLOWED_ORIGIN) {
    return env.ALLOWED_ORIGIN.split(',').map((o) => o.trim()).filter(Boolean);
  }
  return env.NODE_ENV === 'production' ? false : '*';
}

module.exports = { productionConfigProblems, corsOrigin };
