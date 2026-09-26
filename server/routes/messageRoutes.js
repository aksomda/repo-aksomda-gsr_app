const express = require('express');
const router = express.Router();
const controller = require('../controllers/messageController');
const authenticate = require('../middlewares/authenticate');
const requireRole = require('../middlewares/requireRole');

router.get('/messages', authenticate, controller.getConversation);
router.post('/messages', authenticate, controller.sendMessage);
router.get('/messages/threads', authenticate, requireRole('admin'), controller.getThreads);
router.get('/messages/recipients', authenticate, requireRole('admin'), controller.getRecipients);

exports.messageRoutes = router;
