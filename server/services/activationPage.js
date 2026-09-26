// Page HTML affichée dans le navigateur quand l'utilisateur clique sur le lien
// d'activation reçu par email (GET /auth/activate).

const VARIANTS = {
  success: {
    color: '#16a34a',
    soft: '#dcfce7',
    icon: '<path d="M5 13l4 4L19 7" />',
  },
  error: {
    color: '#dc2626',
    soft: '#fee2e2',
    icon: '<path d="M6 6l12 12M18 6L6 18" />',
  },
};

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function renderActivationPage({ variant = 'success', title, message, steps = [] }) {
  const { color, soft, icon } = VARIANTS[variant] || VARIANTS.success;
  const stepsHtml = steps.length
    ? `<ol class="steps">${steps
        .map(
          ({ label, done }) =>
            `<li class="${done ? 'done' : 'todo'}"><span class="dot">${done ? '✓' : '…'}</span>${escapeHtml(label)}</li>`
        )
        .join('')}</ol>`
    : '';

  return `<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>GsrApp — ${escapeHtml(title)}</title>
<style>
  * { box-sizing: border-box; }
  body {
    margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
    padding: 24px; font-family: 'Segoe UI', system-ui, -apple-system, Roboto, sans-serif;
    background: linear-gradient(135deg, #eef2ff 0%, #e0f2fe 100%); color: #1e293b;
  }
  .card {
    width: 100%; max-width: 460px; background: #fff; border-radius: 20px; padding: 40px 32px 32px;
    text-align: center; box-shadow: 0 20px 45px rgba(30, 41, 59, .12);
    animation: rise .5s ease-out both;
  }
  .badge {
    width: 84px; height: 84px; border-radius: 50%; margin: 0 auto 24px;
    background: ${soft}; display: flex; align-items: center; justify-content: center;
  }
  .badge svg {
    width: 42px; height: 42px; fill: none; stroke: ${color}; stroke-width: 3;
    stroke-linecap: round; stroke-linejoin: round;
    stroke-dasharray: 40; stroke-dashoffset: 40; animation: draw .6s .3s ease-out forwards;
  }
  h1 { margin: 0 0 12px; font-size: 24px; color: ${color}; }
  p { margin: 0; line-height: 1.6; color: #475569; }
  .steps { list-style: none; margin: 28px 0 0; padding: 16px 18px; background: #f8fafc; border-radius: 12px; text-align: left; }
  .steps li { display: flex; align-items: center; gap: 12px; padding: 8px 0; font-size: 14px; }
  .steps .dot {
    flex: none; width: 24px; height: 24px; border-radius: 50%; display: inline-flex;
    align-items: center; justify-content: center; font-size: 13px; font-weight: 700;
  }
  .steps .done .dot { background: #16a34a; color: #fff; }
  .steps .todo .dot { background: #fef3c7; color: #b45309; }
  .steps .todo { color: #64748b; }
  .brand { margin-top: 28px; font-size: 12px; letter-spacing: .08em; text-transform: uppercase; color: #94a3b8; }
  @keyframes rise { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: none; } }
  @keyframes draw { to { stroke-dashoffset: 0; } }
</style>
</head>
<body>
  <main class="card">
    <div class="badge"><svg viewBox="0 0 24 24" aria-hidden="true">${icon}</svg></div>
    <h1>${escapeHtml(title)}</h1>
    <p>${escapeHtml(message)}</p>
    ${stepsHtml}
    <div class="brand">GsrApp · Gestion des salles de réunion</div>
  </main>
</body>
</html>`;
}

module.exports = { renderActivationPage };
