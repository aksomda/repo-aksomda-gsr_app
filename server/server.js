require('dotenv').config();

const { productionConfigProblems } = require('./config/security');

const problems = productionConfigProblems();
if (problems.length > 0) {
  console.error('Configuration de production invalide :\n - ' + problems.join('\n - '));
  process.exit(1);
}

const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Serveur Node.js api_GsrApp démarré sur le port ${PORT}`);
});
