const express = require('express');
const router = express.Router();
const userController = require('../controllers/userControllers');
const authenticate = require('../middlewares/authenticate');
const requireRole = require('../middlewares/requireRole');

// Gestion des accès gsr_app par un administrateur (identifiants = login DGI).
router.get('/users', authenticate, requireRole('admin'), userController.listPendingUsers);
router.post('/users/activate-direct', authenticate, requireRole('admin'), userController.activateDirect);
router.post('/users/:login/approve', authenticate, requireRole('admin'), userController.approveUser);
router.post('/users/:login/reject', authenticate, requireRole('admin'), userController.rejectUser);
router.post('/users/:login/reset-password', authenticate, requireRole('admin'), userController.resetPassword);

exports.adminUserRoutes = router;
