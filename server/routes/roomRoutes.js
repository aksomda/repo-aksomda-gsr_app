const express = require('express');
const router = express.Router();
const roomController = require('../controllers/roomControllers');
const authenticate = require('../middlewares/authenticate');
const requireRole = require('../middlewares/requireRole');

router.get('/rooms', authenticate, roomController.getRooms);
router.get('/rooms/available', authenticate, roomController.getAvailableRooms);
router.post('/rooms/save', authenticate, requireRole('admin'), roomController.saveRoom);
router.post('/rooms/delete', authenticate, requireRole('admin'), roomController.deleteRoom);

exports.roomRoutes = router;
