const pool = require('../config/db');
const { logActivity } = require('../services/activityLogger');
const { sendServerError } = require('../utils/errors');

// region/province/city (INT) sont des colonnes héritées, laissées à 0 par
// convention (voir server/sql/README.md). La localisation saisie dans le
// formulaire est stockée dans region_name/province_name/city_name/location.
exports.getRooms = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM room WHERE del = 0');
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

// Salles sans réservation (en attente ou validée) chevauchant le créneau
// [date] [start_time]-[end_time).
exports.getAvailableRooms = async (req, res) => {
  try {
    const { date, start_time, end_time } = req.query;
    if (!date || !start_time || !end_time) {
      return res.status(400).json({ success: false, error: 'date, start_time et end_time sont requis.' });
    }

    const [rows] = await pool.query(
      `SELECT * FROM room WHERE del = 0 AND id NOT IN (
         SELECT room_id FROM reservations
         WHERE date = ?
           AND status IN ('en_attente', 'validee')
           AND start_time < ? AND end_time > ?
       )`,
      [date, end_time, start_time]
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.saveRoom = async (req, res) => {
  try {
    const {
      id, name, hasLocation, hasComputer, computerCount, category_room_id, structure_code, rentalAmount, status,
      region_name, province_name, city_name, location,
    } = req.body;

    const hasLocationVal = hasLocation ? 1 : 0;
    const hasComputerVal = hasComputer ? 1 : 0;

    if (id) {
      await pool.query(
        `UPDATE room SET name=?, hasLocation=?, hasComputer=?, computerCount=?, category_room_id=?,
         structure_code=?, rentalAmount=?, status=?, region_name=?, province_name=?, city_name=?, location=?,
         updated_at=NOW() WHERE id=?`,
        [
          name, hasLocationVal, hasComputerVal, computerCount, category_room_id, structure_code || null, rentalAmount, status,
          region_name || null, province_name || null, city_name || null, location || null, id,
        ]
      );
      await logActivity(pool, { login: req.user.login, action: 'room_update', details: { id }, req });
      res.json({ success: true, message: 'Salle mise à jour avec succès' });
    } else {
      const [result] = await pool.query(
        `INSERT INTO room (name, region, province, city, hasLocation, hasComputer, computerCount,
         category_room_id, structure_code, rentalAmount, status, region_name, province_name, city_name, location,
         created_at, updated_at, del)
         VALUES (?, 0, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), 0)`,
        [
          name, hasLocationVal, hasComputerVal, computerCount, category_room_id, structure_code || null, rentalAmount, status,
          region_name || null, province_name || null, city_name || null, location || null,
        ]
      );
      await logActivity(pool, { login: req.user.login, action: 'room_create', details: { id: result.insertId }, req });
      res.json({ success: true, message: 'Salle créée avec succès' });
    }
  } catch (error) {
    sendServerError(res, error);
  }
};

// Suppression logique (del=1), cohérente avec la convention déjà en place
// sur category_room.
exports.deleteRoom = async (req, res) => {
  try {
    const { id } = req.body;
    await pool.query('UPDATE room SET del = 1, updated_at = NOW() WHERE id = ?', [id]);
    await logActivity(pool, { login: req.user.login, action: 'room_delete', details: { id }, req });
    res.json({ success: true, message: 'Salle supprimée avec succès' });
  } catch (error) {
    sendServerError(res, error);
  }
};
