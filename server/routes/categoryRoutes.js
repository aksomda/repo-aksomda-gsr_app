const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/categoryController');
const authenticate = require('../middlewares/authenticate');
const requireRole = require('../middlewares/requireRole');

router.get('/categories', authenticate, categoryController.getCategories);
router.post('/categories/save', authenticate, requireRole('admin'), categoryController.saveCategory);
router.post('/categories/delete', authenticate, requireRole('admin'), categoryController.deleteCategory);

exports.categoryRoutes = router;
