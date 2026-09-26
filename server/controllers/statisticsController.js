const pool = require('../config/db');
const { sendServerError } = require('../utils/errors');

exports.getRoomStatistics = async (req, res) => {
  try {
    const [byStatus] = await pool.query('SELECT status, COUNT(*) AS total FROM reservations GROUP BY status');

    const [mostRequested] = await pool.query(
      `SELECT rm.id AS room_id, rm.name, COUNT(*) AS total
       FROM reservations r JOIN room rm ON rm.id = r.room_id
       GROUP BY rm.id, rm.name
       ORDER BY total DESC
       LIMIT 10`
    );

    const [byStructure] = await pool.query(
      `SELECT s.LIBELLE_LONG_CDI AS structure, COUNT(*) AS total
       FROM reservations r
       JOIN room rm ON rm.id = r.room_id
       LEFT JOIN ref_structure s ON s.CODE_CDI = rm.structure_code
       GROUP BY s.LIBELLE_LONG_CDI`
    );

    res.json({ byStatus, mostRequested, byStructure });
  } catch (error) {
    sendServerError(res, error);
  }
};
