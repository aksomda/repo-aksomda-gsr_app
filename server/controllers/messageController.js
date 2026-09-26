const pool = require('../config/db');
const { logActivity } = require('../services/activityLogger');
const { createNotification } = require('../services/notifier');
const { sendServerError } = require('../utils/errors');

// Un agent envoie toujours à "l'administration" (recipient_login NULL,
// visible par tous les admins). Un admin doit préciser l'agent destinataire.
exports.sendMessage = async (req, res) => {
  try {
    const { content, recipient_login } = req.body;
    if (!content || !content.trim()) {
      return res.status(400).json({ success: false, error: 'Le message ne peut pas être vide.' });
    }

    let recipientLogin = null;
    if (req.user.role === 'admin') {
      if (!recipient_login) {
        return res.status(400).json({ success: false, error: 'Destinataire requis.' });
      }
      recipientLogin = recipient_login;
    }

    const [result] = await pool.query(
      'INSERT INTO messages (sender_login, recipient_login, content) VALUES (?, ?, ?)',
      [req.user.login, recipientLogin, content.trim()]
    );

    if (recipientLogin) {
      await createNotification(pool, {
        login: recipientLogin,
        title: 'Nouveau message',
        body: content.trim().slice(0, 100),
        type: 'nouveau_message',
        referenceId: result.insertId,
      });
    } else {
      const admins = await pool.query(
        `SELECT DISTINCT u.login FROM users u
         JOIN account_registrations r ON r.login = u.login
         WHERE u.groupe = 7 AND r.approved_at IS NOT NULL`
      );
      await Promise.all(
        admins[0].map((admin) =>
          createNotification(pool, {
            login: admin.login,
            title: 'Nouveau message',
            body: content.trim().slice(0, 100),
            type: 'nouveau_message',
            referenceId: result.insertId,
          })
        )
      );
    }

    await logActivity(pool, { login: req.user.login, action: 'message_send', details: { id: result.insertId }, req });
    res.status(201).json({ success: true, message: 'Message envoyé.', id: result.insertId });
  } catch (error) {
    sendServerError(res, error);
  }
};

// Conversation de l'utilisateur courant. Un agent discute toujours avec
// "l'administration" ; un admin doit préciser ?with=<login agent> pour
// choisir la conversation à afficher.
exports.getConversation = async (req, res) => {
  try {
    if (req.user.role === 'admin') {
      const withLogin = req.query.with;
      if (!withLogin) {
        return res.status(400).json({ success: false, error: 'Paramètre "with" requis.' });
      }
      const [rows] = await pool.query(
        `SELECT * FROM messages
         WHERE (sender_login = ? AND (recipient_login IS NULL OR recipient_login = ?))
            OR (sender_login = ? AND recipient_login = ?)
         ORDER BY created_at ASC`,
        [withLogin, req.user.login, req.user.login, withLogin]
      );
      return res.json(rows);
    }

    const [rows] = await pool.query(
      `SELECT * FROM messages
       WHERE (sender_login = ? AND recipient_login IS NULL) OR recipient_login = ?
       ORDER BY created_at ASC`,
      [req.user.login, req.user.login]
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

// Boîte de réception admin : un agent par conversation, avec le dernier
// message et le nombre de messages non lus envoyés par cet agent.
exports.getThreads = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT u.login, u.nom, u.prenom,
              MAX(m.created_at) AS last_message_at,
              SUM(CASE WHEN m.sender_login = u.login AND m.is_read = 0 THEN 1 ELSE 0 END) AS unread_count
       FROM messages m
       JOIN users u ON u.login = m.sender_login OR u.login = m.recipient_login
       WHERE u.groupe != 7
       GROUP BY u.login, u.nom, u.prenom
       ORDER BY last_message_at DESC`
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

// Agents auxquels un admin peut écrire pour démarrer une nouvelle
// conversation : comptes gsr_app validés, hors administrateurs.
exports.getRecipients = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT u.login, u.nom, u.prenom
       FROM users u
       JOIN account_registrations r ON r.login = u.login
       WHERE r.approved_at IS NOT NULL AND u.groupe != 7
       ORDER BY u.nom, u.prenom`
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};
