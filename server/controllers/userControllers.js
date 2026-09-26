const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const { sendActivationEmail } = require('../services/mailer');
const { logActivity } = require('../services/activityLogger');
const { renderActivationPage } = require('../services/activationPage');
const firebase = require('../config/firebase');
const { sendServerError } = require('../utils/errors');
const bcrypt = require('bcryptjs');

const ACTIVATION_TOKEN_TTL_HOURS = 48;
const BCRYPT_ROUNDS = 12;

function sha1(value) {
  return crypto.createHash('sha1').update(value).digest('hex');
}

// Tout mot de passe que gsr_app écrit lui-même (inscription, activation
// directe par un admin, réinitialisation) est haché avec bcrypt (coût 12) :
// salé, et volontairement coûteux à calculer pour ralentir une attaque par
// force brute en cas de fuite de la base.
async function hashPassword(password) {
  return bcrypt.hash(password, BCRYPT_ROUNDS);
}

function isBcryptHash(value) {
  return typeof value === 'string' && /^\$2[aby]\$/.test(value);
}

// `users.mdp` mélange, selon l'ancienneté du compte, des mots de passe en
// clair et des hachages SHA1 (40 car. hexadécimaux) — schéma hérité d'un
// système existant que gsr_app ne peut pas modifier (voir server/sql/README.md).
// Les comptes gérés par gsr_app depuis ce correctif utilisent bcrypt ; les
// anciens hachages SHA1/mots de passe en clair restent acceptés en lecture
// pour ne pas invalider les comptes existants.
// Comparaison en temps constant pour le repli SHA1/clair : ne révèle pas,
// par le temps de réponse, jusqu'où deux valeurs coïncident.
function safeEqual(a, b) {
  const bufA = Buffer.from(String(a));
  const bufB = Buffer.from(String(b));
  return bufA.length === bufB.length && crypto.timingSafeEqual(bufA, bufB);
}

function passwordMatches(password, storedMdp) {
  if (!storedMdp) return false;
  if (isBcryptHash(storedMdp)) return bcrypt.compareSync(password, storedMdp);
  if (safeEqual(storedMdp, password)) return true;
  if (safeEqual(storedMdp, sha1(password))) return true;
  return false;
}

// groupe=7 est le seul groupe DGI mappé sur le rôle admin de gsr_app
// (décision produit, voir server/sql/README.md) ; tout le reste est agent.
function roleFromGroupe(groupe) {
  return Number(groupe) === 7 ? 'admin' : 'agent';
}

function toPublicUser(row) {
  return {
    login: row.login,
    nom: row.nom,
    prenom: row.prenom,
    telephone: row.telephone,
    numeroFlotte: row.num_flotte,
    email: row.email,
    structureCode: row.CODE_CDI,
    structureLibelle: row.NOM_LONG_CDI,
    role: roleFromGroupe(row.groupe),
    isActive: Number(row.Etat) === 1,
  };
}

// Complète un utilisateur public avec les infos de sa photo de profil (table
// user_profiles, propre à gsr_app — voir profileController.js). Appelé
// uniquement là où le client en a besoin (connexion, profil courant), pas
// dans les listes (listPendingUsers), pour ne pas y ajouter une requête par
// ligne.
async function attachProfile(pool, publicUser) {
  const [rows] = await pool.query(
    'SELECT photo_updated_at, firebase_photo_url FROM user_profiles WHERE login = ?',
    [publicUser.login]
  );
  const profile = rows[0];
  return {
    ...publicUser,
    hasPhoto: !!profile?.photo_updated_at,
    photoUpdatedAt: profile?.photo_updated_at || null,
    firebasePhotoUrl: profile?.firebase_photo_url || null,
  };
}

// Inscription = activer l'accès gsr_app pour un agent DGI déjà présent dans
// `users` (jamais création d'une nouvelle ligne). Le mot de passe choisi
// n'est appliqué à users.mdp qu'après confirmation de l'email (voir
// activate()) ; l'accès reste bloqué tant qu'un administrateur ne l'a pas
// validé (voir approveUser()).
exports.register = async (req, res) => {
  try {
    const { login, email, password } = req.body;
    if (!login || !email || !password) {
      return res.status(400).json({ success: false, error: 'Identifiant, email et mot de passe sont obligatoires.' });
    }
    if (password.length < 8) {
      return res.status(400).json({ success: false, error: 'Le mot de passe doit contenir au moins 8 caractères.' });
    }

    const [rows] = await pool.query('SELECT login, nom, email FROM users WHERE login = ?', [login]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: "Identifiant ou email introuvable." });
    }
    const user = rows[0];
    if (!user.email || user.email.trim().toLowerCase() !== email.trim().toLowerCase()) {
      return res.status(404).json({ success: false, error: "Identifiant ou email introuvable." });
    }

    const activationToken = crypto.randomBytes(32).toString('hex');
    const tokenExpires = new Date(Date.now() + ACTIVATION_TOKEN_TTL_HOURS * 3600 * 1000);
    const pendingHash = await hashPassword(password);

    await pool.query(
      `INSERT INTO account_registrations (login, pending_password_hash, activation_token, token_expires_at)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE pending_password_hash = VALUES(pending_password_hash),
         activation_token = VALUES(activation_token), token_expires_at = VALUES(token_expires_at),
         email_verified_at = NULL, approved_at = NULL, approved_by = NULL, rejected_at = NULL`,
      [login, pendingHash, activationToken, tokenExpires]
    );

    const activationUrl = `${process.env.APP_BASE_URL || 'http://localhost:3000'}/api/gsr/auth/activate?token=${activationToken}`;
    await sendActivationEmail({ to: user.email, nom: user.nom, activationUrl });

    await logActivity(pool, { login, action: 'user_register', req });

    res.status(201).json({
      success: true,
      message: 'Vérifiez votre email pour activer votre accès, puis attendez la validation par un administrateur.',
    });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.activate = async (req, res) => {
  // Lien ouvert depuis un email : on répond par une page HTML, pas du JSON.
  const failure = (status, message) =>
    res.status(status).type('html').send(renderActivationPage({ variant: 'error', title: 'Activation impossible', message }));

  try {
    const { token } = req.query;
    if (!token) {
      return failure(400, 'Lien invalide.');
    }

    const [rows] = await pool.query(
      'SELECT login, pending_password_hash, token_expires_at FROM account_registrations WHERE activation_token = ?',
      [token]
    );
    if (rows.length === 0) {
      return failure(400, 'Lien invalide ou déjà utilisé.');
    }
    const registration = rows[0];
    if (new Date(registration.token_expires_at) < new Date()) {
      return failure(400, 'Ce lien a expiré, veuillez recommencer votre inscription.');
    }

    await pool.query('UPDATE users SET mdp = ?, user_maj = ?, date_maj = CURDATE() WHERE login = ?', [
      registration.pending_password_hash,
      registration.login,
      registration.login,
    ]);
    await pool.query('UPDATE account_registrations SET email_verified_at = NOW() WHERE login = ?', [registration.login]);

    await logActivity(pool, { login: registration.login, action: 'user_email_verified', req });

    res.type('html').send(
      renderActivationPage({
        title: 'Email confirmé !',
        message: 'Merci, votre adresse email est bien vérifiée. Votre accès doit encore être validé par un administrateur.',
        steps: [
          { label: 'Compte créé', done: true },
          { label: 'Adresse email confirmée', done: true },
          { label: 'Validation par un administrateur', done: false },
        ],
      })
    );
  } catch (error) {
    failure(500, 'Une erreur est survenue, veuillez réessayer plus tard.');
  }
};

exports.login = async (req, res) => {
  try {
    const { login: identifier, password } = req.body;
    if (!identifier || !password) {
      return res.status(400).json({ success: false, error: 'Identifiant et mot de passe requis.' });
    }

    // Connexion par identifiant (users.login) ; à défaut, repli sur l'email.
    let [rows] = await pool.query('SELECT * FROM users WHERE login = ?', [identifier]);
    if (rows.length === 0) {
      [rows] = await pool.query('SELECT * FROM users WHERE LOWER(TRIM(email)) = ?', [String(identifier).trim().toLowerCase()]);
    }
    if (rows.length === 0) {
      await logActivity(pool, { action: 'login_failed', details: { identifier }, req });
      return res.status(401).json({ success: false, error: 'Identifiant ou mot de passe incorrect.' });
    }

    // Un même email peut être partagé par plusieurs agents : on retient celui dont le mot de passe correspond.
    const user = rows.find((row) => passwordMatches(password, row.mdp)) || rows[0];
    const login = user.login;
    if (!passwordMatches(password, user.mdp)) {
      await pool.query('UPDATE users SET nbre_tentative = COALESCE(nbre_tentative, 0) + 1 WHERE login = ?', [login]);
      await logActivity(pool, { login, action: 'login_failed', req });
      return res.status(401).json({ success: false, error: 'Identifiant ou mot de passe incorrect.' });
    }

    if (Number(user.Etat) !== 1) {
      return res.status(403).json({ success: false, error: 'Ce compte est inactif.' });
    }

    const [regRows] = await pool.query('SELECT approved_at FROM account_registrations WHERE login = ?', [login]);
    if (regRows.length === 0 || !regRows[0].approved_at) {
      return res.status(403).json({ success: false, error: "Votre accès à GsrApp n'a pas encore été validé par un administrateur." });
    }

    if (!process.env.JWT_SECRET) {
      console.error('JWT_SECRET manquant côté serveur (fichier .env).');
      return res.status(500).json({ success: false, error: 'Configuration serveur invalide.' });
    }

    const role = roleFromGroupe(user.groupe);
    const token = jwt.sign({ login: user.login, role }, process.env.JWT_SECRET, { expiresIn: '8h' });

    await pool.query(
      'UPDATE users SET USR_LAST_CONNECT = NOW(), nbre_de_connexion = COALESCE(nbre_de_connexion, 0) + 1, nbre_tentative = 0 WHERE login = ?',
      [login]
    );
    await logActivity(pool, { login, action: 'login_success', req });

    // Synchronise l'identité avec Firebase Auth (best effort, voir
    // config/firebase.js) : MySQL reste seul responsable de la décision
    // d'authentifier ci-dessus, un échec Firebase ne bloque jamais la
    // connexion gsr_app.
    const firebaseToken = await firebase.createCustomToken(login, { role });
    const publicUser = await attachProfile(pool, toPublicUser(user));

    res.json({ success: true, message: 'Connexion réussie', token, firebaseToken, user: publicUser });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.me = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM users WHERE login = ?', [req.user.login]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Utilisateur introuvable.' });
    }
    res.json(await attachProfile(pool, toPublicUser(rows[0])));
  } catch (error) {
    sendServerError(res, error);
  }
};

// --- Gestion admin (requireRole('admin')) ---

exports.listPendingUsers = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT u.*
       FROM account_registrations r
       JOIN users u ON u.login = r.login
       WHERE r.email_verified_at IS NOT NULL AND r.approved_at IS NULL AND r.rejected_at IS NULL
       ORDER BY r.created_at DESC`
    );
    res.json(rows.map(toPublicUser));
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.approveUser = async (req, res) => {
  try {
    const { login } = req.params;
    const [result] = await pool.query(
      'UPDATE account_registrations SET approved_at = NOW(), approved_by = ?, rejected_at = NULL WHERE login = ?',
      [req.user.login, login]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: "Aucune demande d'inscription pour cet identifiant." });
    }
    await logActivity(pool, { login: req.user.login, action: 'user_approve', details: { targetLogin: login }, req });
    res.json({ success: true, message: 'Accès validé.' });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.rejectUser = async (req, res) => {
  try {
    const { login } = req.params;
    const [result] = await pool.query(
      'UPDATE account_registrations SET rejected_at = NOW(), approved_at = NULL WHERE login = ?',
      [login]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: "Aucune demande d'inscription pour cet identifiant." });
    }
    await logActivity(pool, { login: req.user.login, action: 'user_reject', details: { targetLogin: login }, req });
    res.json({ success: true, message: 'Accès rejeté.' });
  } catch (error) {
    sendServerError(res, error);
  }
};

// Un administrateur active directement l'accès d'un agent DGI existant
// (sans passer par l'email) : choisit un login déjà présent dans `users`,
// fixe un mot de passe, et approuve immédiatement.
exports.activateDirect = async (req, res) => {
  try {
    const { login, password } = req.body;
    if (!login || !password) {
      return res.status(400).json({ success: false, error: 'Identifiant et mot de passe requis.' });
    }
    if (password.length < 8) {
      return res.status(400).json({ success: false, error: 'Le mot de passe doit contenir au moins 8 caractères.' });
    }

    const [rows] = await pool.query('SELECT login FROM users WHERE login = ?', [login]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Aucun agent trouvé avec cet identifiant.' });
    }

    const hashed = await hashPassword(password);
    await pool.query('UPDATE users SET mdp = ?, user_maj = ?, date_maj = CURDATE() WHERE login = ?', [
      hashed,
      req.user.login,
      login,
    ]);
    await pool.query(
      `INSERT INTO account_registrations (login, pending_password_hash, activation_token, token_expires_at, email_verified_at, approved_at, approved_by)
       VALUES (?, ?, ?, NOW(), NOW(), NOW(), ?)
       ON DUPLICATE KEY UPDATE pending_password_hash = VALUES(pending_password_hash), email_verified_at = NOW(),
         approved_at = NOW(), approved_by = VALUES(approved_by), rejected_at = NULL`,
      [login, hashed, crypto.randomBytes(16).toString('hex'), req.user.login]
    );

    await logActivity(pool, { login: req.user.login, action: 'user_activate_direct', details: { targetLogin: login }, req });
    res.status(201).json({ success: true, message: 'Accès activé pour cet agent.' });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.resetPassword = async (req, res) => {
  try {
    const { login } = req.params;
    const temporaryPassword = crypto.randomBytes(6).toString('hex');
    const hashed = await hashPassword(temporaryPassword);

    const [result] = await pool.query(
      'UPDATE users SET mdp = ?, user_resset = ?, date_resset = CURDATE() WHERE login = ?',
      [hashed, req.user.login, login]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: 'Utilisateur introuvable.' });
    }

    await logActivity(pool, { login: req.user.login, action: 'user_password_reset', details: { targetLogin: login }, req });
    res.json({ success: true, message: 'Mot de passe réinitialisé.', temporaryPassword });
  } catch (error) {
    sendServerError(res, error);
  }
};
