const nodemailer = require('nodemailer');

// Configuré par variables d'environnement (voir .env.example). Tant que
// SMTP_HOST n'est pas renseigné, les emails sont simplement journalisés en
// console pour ne pas bloquer le développement local.
function buildTransport() {
  if (!process.env.SMTP_HOST) {
    return null;
  }
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT) || 587,
    secure: Number(process.env.SMTP_PORT) === 465,
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASSWORD,
    },
  });
}

async function sendActivationEmail({ to, nom, activationUrl }) {
  const transport = buildTransport();
  const subject = 'Activez votre compte GsrApp';
  const html = `
    <p>Bonjour ${nom},</p>
    <p>Votre compte GsrApp a été créé. Cliquez sur le lien ci-dessous pour confirmer votre adresse email :</p>
    <p><a href="${activationUrl}">${activationUrl}</a></p>
    <p>Un administrateur devra ensuite valider votre compte avant que vous puissiez vous connecter.</p>
  `;

  if (!transport) {
    console.log(`[mailer] SMTP non configuré — lien d'activation pour ${to} : ${activationUrl}`);
    return;
  }

  await transport.sendMail({
    from: process.env.SMTP_FROM || 'no-reply@gsrapp.local',
    to,
    subject,
    html,
  });
}

module.exports = { sendActivationEmail };
