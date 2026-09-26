require('dotenv').config();

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

const pool = require('./config/db');
const { auditRequests } = require('./services/activityLogger');
const { corsOrigin } = require('./config/security');

const { roomRoutes } = require('./routes/roomRoutes');
const { userRoutes } = require('./routes/userRoutes');
const { adminUserRoutes } = require('./routes/adminUserRoutes');
const { categoryRoutes } = require('./routes/categoryRoutes');
const { structureRoutes } = require('./routes/structureRoutes');
const { reservationRoutes } = require('./routes/reservationRoutes');
const { notificationRoutes } = require('./routes/notificationRoutes');
const { messageRoutes } = require('./routes/messageRoutes');
const { statisticsRoutes } = require('./routes/statisticsRoutes');
const { healthRoutes } = require('./routes/healthRoutes');
const { profileRoutes } = require('./routes/profileRoutes');

const app = express();

app.use(helmet());
app.use(cors({ origin: corsOrigin(), exposedHeaders: ['X-Has-More'] }));
app.use(express.json());
// Avant l'audit : le test de connexion ne doit pas être journalisé.
app.use('/api/gsr', healthRoutes);
app.use(auditRequests(pool));

// Limite les tentatives de connexion/inscription pour freiner le brute-force.
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Trop de tentatives, réessayez plus tard.' },
});
app.use('/api/gsr/auth/login', authLimiter);
app.use('/api/gsr/auth/register', authLimiter);

// Routes principales de l'API
app.use('/api/gsr', roomRoutes);
app.use('/api/gsr', categoryRoutes);
app.use('/api/gsr', structureRoutes);
app.use('/api/gsr', reservationRoutes);
app.use('/api/gsr', notificationRoutes);
app.use('/api/gsr', messageRoutes);
app.use('/api/gsr', statisticsRoutes);
app.use('/api/gsr', adminUserRoutes);
app.use('/api/gsr', profileRoutes);
app.use('/api/gsr/auth', userRoutes);

// Gestionnaire d'erreurs centralisé : filet de sécurité pour tout ce qui
// n'est pas déjà intercepté par le try/catch d'un contrôleur (JSON de requête
// malformé, erreur multer non gérée, etc.). Ne renvoie jamais le détail
// interne (message, pile d'appel) au client, indépendamment de NODE_ENV —
// contrairement au gestionnaire par défaut d'Express.
app.use((err, req, res, next) => {
  if (res.headersSent) return next(err);
  console.error(err);
  const status = Number.isInteger(err.status) ? err.status : 500;
  res.status(status).json({ success: false, error: 'Une erreur interne est survenue.' });
});

module.exports = app;
