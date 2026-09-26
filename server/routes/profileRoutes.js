const express = require('express');
const multer = require('multer');
const router = express.Router();
const controller = require('../controllers/profileController');
const authenticate = require('../middlewares/authenticate');

// En mémoire (pas de fichier temporaire sur disque) : le buffer va
// directement dans user_profiles.photo_blob (MySQL = stockage principal).
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
});

function handleUploadError(err, req, res, next) {
  if (err instanceof multer.MulterError) {
    return res.status(400).json({ success: false, error: 'Photo trop volumineuse (5 Mo maximum).' });
  }
  next(err);
}

router.get('/profile/photo/:login', authenticate, controller.getPhoto);
router.post('/profile/photo', authenticate, upload.single('photo'), handleUploadError, controller.uploadPhoto);
router.delete('/profile/photo', authenticate, controller.deletePhoto);

exports.profileRoutes = router;
