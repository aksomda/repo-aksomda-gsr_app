const { sendPush } = require('../config/firebase');

// Crée une notification in-app pour un utilisateur (consultée par polling
// côté client, voir notificationController.getNotifications) puis tente une
// notification push sur ses appareils connus (voir pushToUser ci-dessous).
// Appelée depuis messageController (nouveau message) et reservationController
// (réservation validée/rejetée) : ces deux événements bénéficient donc du
// push sans code supplémentaire dans ces contrôleurs.
async function createNotification(pool, { login, title, body, type, referenceId = null }) {
  await pool.query(
    'INSERT INTO notifications (user_login, title, body, type, reference_id) VALUES (?, ?, ?, ?, ?)',
    [login, title, body, type, referenceId]
  );
  await pushToUser(pool, login, { title, body, data: { type, referenceId: referenceId ?? '' } });
}

// Best effort : ne fait jamais échouer l'appelant (la notification in-app
// ci-dessus est déjà écrite, elle reste la source de vérité consultée par
// l'application). Purge les jetons que Firebase signale comme invalides.
async function pushToUser(pool, login, { title, body, data = {} }) {
  try {
    const [rows] = await pool.query('SELECT token FROM fcm_tokens WHERE user_login = ?', [login]);
    if (rows.length === 0) return;

    const tokens = rows.map((r) => r.token);
    const { invalidTokens } = await sendPush(tokens, { title, body, data });
    if (invalidTokens.length > 0) {
      await pool.query('DELETE FROM fcm_tokens WHERE token IN (?)', [invalidTokens]);
    }
  } catch (error) {
    console.error('[notifier] pushToUser a échoué :', error.message);
  }
}

module.exports = { createNotification, pushToUser };
