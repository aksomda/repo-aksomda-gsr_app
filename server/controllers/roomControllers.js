const pool = require('../config/db');

// Récupérer toutes les salles
exports.getRooms = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM rooms');
    res.json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Créer ou Mettre à jour une salle (INSERT / UPDATE)
exports.saveRoom = async (req, res) => {
  try {
    const { id, name, region, province, city, location, has_computer, computer_count, category, rental_amount, status } = req.body;
    
    const compVal = has_computer ? 1 : 0;

    if (id) {
      // UPDATE
      const query = `UPDATE rooms SET name=?, region=?, province=?, city=?, location=?, has_computer=?, computer_count=?, category=?, rental_amount=?, status=? WHERE id=?`;
      await pool.query(query, [name, region, province, city, location, compVal, computer_count, category, rental_amount, status, id]);
      res.json({ success: true, message: 'Salle mise à jour avec succès' });
    } else {
      // INSERT
      const query = `INSERT INTO rooms (name, region, province, city, location, has_computer, computer_count, category, rental_amount, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
      await pool.query(query, [name, region, province, city, location, compVal, computer_count, category, rental_amount, status]);
      res.json({ success: true, message: 'Salle créée avec succès' });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Supprimer une salle (DELETE)
exports.deleteRoom = async (req, res) => {
  try {
    const { id } = req.body;
    await pool.query('DELETE FROM rooms WHERE id = ?', [id]);
    res.json({ success: true, message: 'Salle supprimée avec succès' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};