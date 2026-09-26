const express = require('express');
const router = express.Router();
const userController = require('../controllers/userControllers');
const authenticate = require('../middlewares/authenticate');

router.post('/register', userController.register);
router.get('/activate', userController.activate);
router.post('/login', userController.login);
router.get('/me', authenticate, userController.me);

exports.userRoutes = router;
