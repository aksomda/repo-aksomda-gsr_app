// Intégration Firebase (Auth, Cloud Messaging, Storage) : optionnelle et
// dégradée proprement si non configurée (voir FIREBASE_SETUP.md). MySQL reste
// la source de vérité pour l'identité (users) et pour les photos de profil
// (user_profiles.photo_blob) ; Firebase ne fait que refléter ces données pour
// bénéficier de son SDK côté mobile (session Firebase Auth, notifications
// push, CDN Storage). Toute panne ou absence de configuration Firebase laisse
// gsr_app pleinement fonctionnel : voir chaque fonction ci-dessous.
const fs = require('fs');
const path = require('path');

let admin = null;
let app = null;
let initError = null;

function credentialsPath() {
  return process.env.FIREBASE_SERVICE_ACCOUNT_PATH
    ? path.resolve(process.env.FIREBASE_SERVICE_ACCOUNT_PATH)
    : path.join(__dirname, '..', 'firebase-service-account.json');
}

function init() {
  if (app || initError) return;
  const credPath = credentialsPath();
  if (!fs.existsSync(credPath)) {
    initError = new Error(`Fichier de compte de service Firebase introuvable (${credPath})`);
    return;
  }
  try {
    // Chargé seulement si le fichier existe : ne bloque jamais le démarrage
    // du serveur quand Firebase n'est pas configuré.
    admin = require('firebase-admin');
    const serviceAccount = JSON.parse(fs.readFileSync(credPath, 'utf8'));
    app = admin.apps.length
      ? admin.app()
      : admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          storageBucket: process.env.FIREBASE_STORAGE_BUCKET || `${serviceAccount.project_id}.appspot.com`,
        });
  } catch (error) {
    initError = error;
    console.error('[firebase] Initialisation impossible :', error.message);
  }
}

function isEnabled() {
  init();
  return !!app;
}

async function ensureFirebaseUser(login) {
  try {
    await admin.auth().getUser(login);
  } catch (error) {
    if (error.code === 'auth/user-not-found') {
      await admin.auth().createUser({ uid: login });
    } else {
      throw error;
    }
  }
}

// Jeton personnalisé permettant au client mobile d'ouvrir une session
// Firebase Auth synchronisée avec l'identité déjà vérifiée côté MySQL
// (uid Firebase = users.login) ; renvoie null si Firebase n'est pas
// configuré ou si l'appel échoue (la connexion gsr_app elle-même n'en
// dépend jamais : voir userControllers.login).
async function createCustomToken(login, claims = {}) {
  if (!isEnabled()) return null;
  try {
    await ensureFirebaseUser(login);
    await admin.auth().setCustomUserClaims(login, claims);
    return await admin.auth().createCustomToken(login, claims);
  } catch (error) {
    console.error('[firebase] createCustomToken a échoué :', error.message);
    return null;
  }
}

// Envoi "best effort" : une notification déjà écrite en base (MySQL, voir
// services/notifier.js) n'est jamais perdue si l'envoi push échoue (token
// expiré, Firebase indisponible...). Les jetons rejetés par FCM sont
// renvoyés pour être supprimés de la table fcm_tokens par l'appelant.
async function sendPush(tokens, { title, body, data = {} }) {
  if (!isEnabled() || tokens.length === 0) return { sent: 0, invalidTokens: [] };
  try {
    const stringData = Object.fromEntries(Object.entries(data).map(([k, v]) => [k, String(v)]));
    const response = await admin.messaging().sendEachForMulticast({
      tokens,
      notification: { title, body },
      data: stringData,
    });
    const invalidCodes = ['messaging/registration-token-not-registered', 'messaging/invalid-registration-token'];
    const invalidTokens = response.responses
      .map((r, i) => (!r.success && invalidCodes.includes(r.error?.code) ? tokens[i] : null))
      .filter(Boolean);
    return { sent: response.successCount, invalidTokens };
  } catch (error) {
    console.error('[firebase] sendPush a échoué :', error.message);
    return { sent: 0, invalidTokens: [] };
  }
}

// Miroir Storage d'une photo dont MySQL reste l'original : best effort,
// n'importe quel échec (quota, config, réseau) n'empêche jamais l'upload
// MySQL, déjà effectué par l'appelant (voir profileController.uploadPhoto).
async function uploadPhoto(login, buffer, contentType) {
  if (!isEnabled()) return null;
  try {
    const bucket = admin.storage().bucket();
    const file = bucket.file(`profile-photos/${login}`);
    await file.save(buffer, { contentType, resumable: false });
    await file.makePublic();
    return `https://storage.googleapis.com/${bucket.name}/profile-photos/${login}`;
  } catch (error) {
    console.error('[firebase] uploadPhoto a échoué :', error.message);
    return null;
  }
}

async function deletePhoto(login) {
  if (!isEnabled()) return;
  try {
    await admin.storage().bucket().file(`profile-photos/${login}`).delete({ ignoreNotFound: true });
  } catch (error) {
    console.error('[firebase] deletePhoto a échoué :', error.message);
  }
}

// Réservé aux tests : force une réinitialisation (le module est mis en
// cache par Node/Jest entre les require() d'un même fichier de test).
function _resetForTests() {
  admin = null;
  app = null;
  initError = null;
}

module.exports = {
  isEnabled,
  createCustomToken,
  sendPush,
  uploadPhoto,
  deletePhoto,
  _resetForTests,
};
