const express = require('express');
const router = express.Router();
const controller = require('../controllers/structureController');
const authenticate = require('../middlewares/authenticate');

// Public : consulté depuis le formulaire d'inscription, avant authentification.
// ref_structure appartient à un autre système : lecture seule, jamais de
// création/modification/suppression depuis gsr_app.
router.get('/structures', controller.getStructures);
router.get('/directions-regionales', authenticate, controller.getDirectionsRegionales);

exports.structureRoutes = router;
