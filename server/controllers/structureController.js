const pool = require('../config/db');
const { sendServerError } = require('../utils/errors');

// `ref_structure` appartient à un autre système (intranet DGI) : gsr_app ne
// fait que la lire, jamais la modifier. Route publique (consultée depuis le
// formulaire d'inscription, avant authentification).
exports.getStructures = async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT CODE_CDI AS code_cdi, LIBELLE_LONG_CDI AS libelle_long_cdi, LOCALITE_CDI AS localite_cdi FROM ref_structure ORDER BY LIBELLE_LONG_CDI'
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};

// Directions régionales des impôts : sous-ensemble de ref_structure (lecture
// seule, comme le reste de cette table). Le code CDI sert d'identifiant et est
// stocké dans room.structure_code.
exports.getDirectionsRegionales = async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT CODE_CDI AS code_cdi, LIBELLE_LONG_CDI AS libelle_long_cdi, LOCALITE_CDI AS localite_cdi
       FROM ref_structure
       WHERE LIBELLE_LONG_CDI LIKE 'DIRECTION RÉGIONALE DES IMPÔTS%' or
       LIBELLE_LONG_CDI='DIRECTION GÉNÉRALE DES IMPÔTS'
       ORDER BY LIBELLE_LONG_CDI`
    );
    res.json(rows);
  } catch (error) {
    sendServerError(res, error);
  }
};
