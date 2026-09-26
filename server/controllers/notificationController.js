const pool = require('../config/db');
const { pageParams, sendPage } = require('../services/pagination');
const { sendServerError } = require('../utils/errors');

exports.getNotifications = async (req, res) => {
  try {
    const { limit, offset } = pageParams(req.query, 100);
    const [rows] = await pool.query(
      'SELECT * FROM notifications WHERE user_login = ? ORDER BY created_at DESC LIMIT ? OFFSET ?',
      [req.user.login, limit + 1, offset]
    );
    sendPage(res, rows, limit);
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.markAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await pool.query(
      'UPDATE notifications SET is_read = 1 WHERE id = ? AND user_login = ?',
      [id, req.user.login]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, error: 'Notification introuvable.' });
    }
    res.json({ success: true });
  } catch (error) {
    sendServerError(res, error);
  }
};

// Enregistre le jeton FCM de l'appareil courant pour recevoir les
// notifications push (voir services/notifier.js). Un jeton appartient à un
// seul appareil : le réenregistrer sous un autre compte le réattribue.
exports.registerFcmToken = async (req, res) => {
  try {
    const { token, platform } = req.body;
    if (!token) {
      return res.status(400).json({ success: false, error: 'Jeton requis.' });
    }
    await pool.query(
      `INSERT INTO fcm_tokens (user_login, token, platform) VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE user_login = VALUES(user_login), platform = VALUES(platform), updated_at = NOW()`,
      [req.user.login, token, platform || null]
    );
    res.json({ success: true });
  } catch (error) {
    sendServerError(res, error);
  }
};

// Appelé à la déconnexion : l'appareil ne doit plus recevoir de push pour ce
// compte (il pourra s'être ré-enregistré sous un autre login entre-temps).
exports.unregisterFcmToken = async (req, res) => {
  try {
    const { token } = req.body;
    if (!token) {
      return res.status(400).json({ success: false, error: 'Jeton requis.' });
    }
    await pool.query('DELETE FROM fcm_tokens WHERE token = ? AND user_login = ?', [token, req.user.login]);
    res.json({ success: true });
  } catch (error) {
    sendServerError(res, error);
  }
};
