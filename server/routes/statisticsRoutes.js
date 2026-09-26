const express = require('express');
const router = express.Router();
const controller = require('../controllers/statisticsController');
const authenticate = require('../middlewares/authenticate');

// Statistiques agrégées (aucune donnée nominative) : accessibles à tout
// utilisateur connecté, affichées sur le tableau de bord de chacun — voir
// lib/features/dashboard et lib/features/statistics côté client. Ne pas
// restreindre à `requireRole('admin')` sans adapter le client.
router.get('/statistics/rooms', authenticate, controller.getRoomStatistics);

exports.statisticsRoutes = router;
