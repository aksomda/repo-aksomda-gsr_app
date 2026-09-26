const pool = require('../config/db');
const firebase = require('../config/firebase');
const { logActivity } = require('../services/activityLogger');
const { sendServerError } = require('../utils/errors');

const MAX_PHOTO_BYTES = 5 * 1024 * 1024;
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];

// Consultation façon annuaire : tout utilisateur authentifié peut voir la
// photo d'un collègue (ex: avatar dans la messagerie admin). Seule la
// modification est réservée au propriétaire (voir uploadPhoto/deletePhoto).
exports.getPhoto = async (req, res) => {
  try {
    const { login } = req.params;
    const [rows] = await pool.query(
      'SELECT photo_blob, photo_content_type FROM user_profiles WHERE login = ?',
      [login]
    );
    if (rows.length === 0 || !rows[0].photo_blob) {
      return res.status(404).json({ success: false, error: 'Aucune photo de profil.' });
    }
    res.set('Content-Type', rows[0].photo_content_type || 'application/octet-stream');
    res.set('Cache-Control', 'private, max-age=3600');
    res.send(rows[0].photo_blob);
  } catch (error) {
    sendServerError(res, error);
  }
};

// MySQL (user_profiles.photo_blob) est le stockage principal : cette requête
// n'échoue jamais à cause de Firebase. Le miroir Firebase Storage est tenté
// ensuite, en best effort (voir config/firebase.uploadPhoto).
exports.uploadPhoto = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, error: 'Fichier "photo" requis.' });
    }
    if (!ALLOWED_TYPES.includes(req.file.mimetype)) {
      return res.status(400).json({ success: false, error: 'Formats acceptés : JPEG, PNG, WEBP.' });
    }
    if (req.file.size > MAX_PHOTO_BYTES) {
      return res.status(400).json({ success: false, error: 'Photo trop volumineuse (5 Mo maximum).' });
    }

    const login = req.user.login;
    await pool.query(
      `INSERT INTO user_profiles (login, photo_blob, photo_content_type, photo_size, photo_updated_at)
       VALUES (?, ?, ?, ?, NOW())
       ON DUPLICATE KEY UPDATE photo_blob = VALUES(photo_blob), photo_content_type = VALUES(photo_content_type),
         photo_size = VALUES(photo_size), photo_updated_at = NOW(), firebase_photo_url = NULL`,
      [login, req.file.buffer, req.file.mimetype, req.file.size]
    );

    const firebaseUrl = await firebase.uploadPhoto(login, req.file.buffer, req.file.mimetype);
    if (firebaseUrl) {
      await pool.query('UPDATE user_profiles SET firebase_photo_url = ? WHERE login = ?', [firebaseUrl, login]);
    }

    await logActivity(pool, { login, action: 'profile_photo_upload', req });
    res.json({ success: true, message: 'Photo de profil mise à jour.', firebaseSynced: !!firebaseUrl });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.deletePhoto = async (req, res) => {
  try {
    const login = req.user.login;
    await pool.query(
      `UPDATE user_profiles
       SET photo_blob = NULL, photo_content_type = NULL, photo_size = NULL, photo_updated_at = NULL, firebase_photo_url = NULL
       WHERE login = ?`,
      [login]
    );
    await firebase.deletePhoto(login);
    await logActivity(pool, { login, action: 'profile_photo_delete', req });
    res.json({ success: true, message: 'Photo de profil supprimée.' });
  } catch (error) {
    sendServerError(res, error);
  }
};
