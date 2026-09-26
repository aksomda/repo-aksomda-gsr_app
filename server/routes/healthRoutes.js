const express = require('express');
const router = express.Router();
const pool = require('../config/db');

// Public : sert au test de connexion de l'écran Paramètres. Monté avant le
// middleware d'audit (voir app.js) pour ne pas remplir activity_logs.
router.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: true });
  } catch (error) {
    res.status(503).json({ status: 'degraded', database: false });
  }
});

exports.healthRoutes = router;
