const express = require('express');
const cors = require('cors');
const { roomRoutes } = require('./routes/roomRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes principales de l'API
app.use('/api/gsr', roomRoutes);

app.listen(PORT, () => {
  console.log(`Serveur Node.js api_GsrApp démarré sur le port ${PORT}`);
});