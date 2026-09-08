const express = require('express');
const router = express.Router();
const roomController = require('../controllers/roomController');

router.get('/rooms', roomController.getRooms);
router.post('/rooms/save', roomController.saveRoom);
router.post('/rooms/delete', roomController.deleteRoom);

exports.roomRoutes = router;