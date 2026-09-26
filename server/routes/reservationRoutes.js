const express = require('express');
const router = express.Router();
const controller = require('../controllers/reservationController');
const authenticate = require('../middlewares/authenticate');
const requireRole = require('../middlewares/requireRole');

router.post('/reservations', authenticate, controller.createReservation);
router.get('/reservations/mine', authenticate, controller.getMyReservations);
router.get('/reservations', authenticate, requireRole('admin'), controller.getAllReservations);
router.post('/reservations/:id/validate', authenticate, requireRole('admin'), controller.validateReservation);
router.post('/reservations/:id/reject', authenticate, requireRole('admin'), controller.rejectReservation);

exports.reservationRoutes = router;
