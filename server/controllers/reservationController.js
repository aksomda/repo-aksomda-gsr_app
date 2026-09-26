const pool = require('../config/db');
const { pageParams, sendPage } = require('../services/pagination');
const { logActivity } = require('../services/activityLogger');
const { createNotification } = require('../services/notifier');
const { sendServerError } = require('../utils/errors');

// Crée une demande de réservation. Revérifie la disponibilité dans une
// transaction (SELECT ... FOR UPDATE) pour éviter qu'une course entre deux
// demandes concurrentes sur la même salle ne les valide toutes les deux.
exports.createReservation = async (req, res) => {
  const { room_id, meeting_subject, organizing_structure, date, start_time, end_time } = req.body;

  if (!room_id || !meeting_subject || !organizing_structure || !date || !start_time || !end_time) {
    return res.status(400).json({ success: false, error: 'Tous les champs sont obligatoires.' });
  }
  if (start_time >= end_time) {
    return res.status(400).json({ success: false, error: "L'heure de fin doit être après l'heure de début." });
  }

  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const [conflicts] = await connection.query(
      `SELECT id FROM reservations
       WHERE room_id = ? AND date = ? AND status IN ('en_attente', 'validee')
         AND start_time < ? AND end_time > ?
       FOR UPDATE`,
      [room_id, date, end_time, start_time]
    );

    if (conflicts.length > 0) {
      await connection.rollback();
      return res.status(409).json({ success: false, error: "Cette salle n'est plus disponible sur ce créneau." });
    }

    const [result] = await connection.query(
      `INSERT INTO reservations (room_id, user_login, meeting_subject, organizing_structure, date, start_time, end_time)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [room_id, req.user.login, meeting_subject, organizing_structure, date, start_time, end_time]
    );

    await connection.commit();
    await logActivity(pool, { login: req.user.login, action: 'reservation_create', details: { id: result.insertId, room_id }, req });
    res.status(201).json({ success: true, message: 'Demande de réservation envoyée.', id: result.insertId });
  } catch (error) {
    await connection.rollback();
    sendServerError(res, error);
  } finally {
    connection.release();
  }
};

exports.getMyReservations = async (req, res) => {
  try {
    const { limit, offset } = pageParams(req.query);
    const [rows] = await pool.query(
      `SELECT r.*, rm.name AS room_name FROM reservations r
       JOIN room rm ON rm.id = r.room_id
       WHERE r.user_login = ? ORDER BY r.date DESC, r.start_time DESC
       LIMIT ? OFFSET ?`,
      [req.user.login, limit + 1, offset]
    );
    sendPage(res, rows, limit);
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.getAllReservations = async (req, res) => {
  try {
    const { status } = req.query;
    const { limit, offset } = pageParams(req.query);
    const params = [];
    let where = '';
    if (status) {
      where = 'WHERE r.status = ?';
      params.push(status);
    }
    const [rows] = await pool.query(
      `SELECT r.*, rm.name AS room_name, u.nom, u.prenom FROM reservations r
       JOIN room rm ON rm.id = r.room_id
       JOIN users u ON u.login = r.user_login
       ${where}
       ORDER BY r.date DESC, r.start_time DESC
       LIMIT ? OFFSET ?`,
      [...params, limit + 1, offset]
    );
    sendPage(res, rows, limit);
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.validateReservation = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query('SELECT * FROM reservations WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Réservation introuvable.' });
    }

    await pool.query("UPDATE reservations SET status = 'validee' WHERE id = ?", [id]);
    await createNotification(pool, {
      login: rows[0].user_login,
      title: 'Réservation validée',
      body: `Votre demande "${rows[0].meeting_subject}" du ${rows[0].date} a été validée.`,
      type: 'reservation_validee',
      referenceId: Number(id),
    });
    await logActivity(pool, { login: req.user.login, action: 'reservation_validate', details: { id: Number(id) }, req });
    res.json({ success: true, message: 'Réservation validée.' });
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.rejectReservation = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;
    const [rows] = await pool.query('SELECT * FROM reservations WHERE id = ?', [id]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Réservation introuvable.' });
    }

    await pool.query("UPDATE reservations SET status = 'rejetee', rejection_reason = ? WHERE id = ?", [reason || null, id]);
    await createNotification(pool, {
      login: rows[0].user_login,
      title: 'Réservation rejetée',
      body: `Votre demande "${rows[0].meeting_subject}" du ${rows[0].date} a été rejetée${reason ? ' : ' + reason : '.'}`,
      type: 'reservation_rejetee',
      referenceId: Number(id),
    });
    await logActivity(pool, { login: req.user.login, action: 'reservation_reject', details: { id: Number(id), reason }, req });
    res.json({ success: true, message: 'Réservation rejetée.' });
  } catch (error) {
    sendServerError(res, error);
  }
};
