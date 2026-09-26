const express = require('express');
const router = express.Router();
const controller = require('../controllers/notificationController');
const authenticate = require('../middlewares/authenticate');

router.get('/notifications', authenticate, controller.getNotifications);
router.post('/notifications/:id/read', authenticate, controller.markAsRead);
router.post('/fcm/token', authenticate, controller.registerFcmToken);
router.delete('/fcm/token', authenticate, controller.unregisterFcmToken);

exports.notificationRoutes = router;
