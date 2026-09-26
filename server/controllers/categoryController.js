const pool = require('../config/db');
const { logActivity } = require('../services/activityLogger');
const { sendServerError } = require('../utils/errors');

// Le "type" (gratuite/location) n'est pas une colonne stockée : dérivé de
// montant_location (0 => gratuite, > 0 => location) à la fois ici et côté
// client, pour éviter de dupliquer l'information.
exports.getCategories = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM category_room WHERE del = 0 ORDER BY libelle_cat');
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.saveCategory = async (req, res) => {
  try {
    const { id, libelle_cat, montant_location, actif } = req.body;
    const montant = Number(montant_location) || 0;

    if (id) {
      await pool.query(
        'UPDATE category_room SET libelle_cat=?, montant_location=?, actif=?, updated_at=NOW() WHERE id=?',
        [libelle_cat, montant, actif ? 1 : 0, id]
      );
      await logActivity(pool, { login: req.user.login, action: 'category_update', details: { id }, req });
      res.json({ success: true, message: 'Catégorie mise à jour avec succès' });
    } else {
      const [result] = await pool.query(
        'INSERT INTO category_room (libelle_cat, montant_location, actif, created_at, updated_at, del) VALUES (?, ?, ?, NOW(), NOW(), 0)',
        [libelle_cat, montant, actif ? 1 : 0]
      );
      await logActivity(pool, { login: req.user.login, action: 'category_create', details: { id: result.insertId }, req });
      res.json({ success: true, message: 'Catégorie créée avec succès' });
    }
  } catch (error) {
    sendServerError(res, error);
  }
};

exports.deleteCategory = async (req, res) => {
  try {
    const { id } = req.body;
    await pool.query('UPDATE category_room SET del = 1, updated_at = NOW() WHERE id = ?', [id]);
    await logActivity(pool, { login: req.user.login, action: 'category_delete', details: { id }, req });
    res.json({ success: true, message: 'Catégorie supprimée avec succès' });
  } catch (error) {
    sendServerError(res, error);
  }
};
