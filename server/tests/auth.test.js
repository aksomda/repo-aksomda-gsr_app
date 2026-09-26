jest.mock('../config/db');
jest.mock('../services/mailer', () => ({ sendActivationEmail: jest.fn().mockResolvedValue() }));
jest.mock('../config/firebase', () => ({ createCustomToken: jest.fn().mockResolvedValue(null) }));

const request = require('supertest');
const pool = require('../config/db');
const { sendActivationEmail } = require('../services/mailer');
const firebase = require('../config/firebase');
const app = require('../app');
const { makeToken } = require('./helpers');

describe('POST /api/gsr/auth/register', () => {
  it('refuse si un champ obligatoire manque', async () => {
    const res = await request(app).post('/api/gsr/auth/register').send({ login: '217071K' });
    expect(res.status).toBe(400);
  });

  it("refuse si l'identifiant n'existe pas dans users", async () => {
    pool.query.mockResolvedValueOnce([[]]);

    const res = await request(app).post('/api/gsr/auth/register').send({
      login: 'INCONNU', email: 'a@a.com', password: 'secret123',
    });

    expect(res.status).toBe(404);
  });

  it("refuse si l'email ne correspond pas à celui du dossier existant", async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', nom: 'OUEDRAOGO', email: 'vrai@mail.com' }]]);

    const res = await request(app).post('/api/gsr/auth/register').send({
      login: '217071K', email: 'faux@mail.com', password: 'secret123',
    });

    expect(res.status).toBe(400);
  });

  it("enregistre une demande d'activation et envoie l'email si login+email correspondent", async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', nom: 'OUEDRAOGO', email: 'vrai@mail.com' }]]);
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // upsert account_registrations

    const res = await request(app).post('/api/gsr/auth/register').send({
      login: '217071K', email: 'vrai@mail.com', password: 'secret123',
    });

    expect(res.status).toBe(201);
    expect(res.body.success).toBe(true);
    expect(sendActivationEmail).toHaveBeenCalledWith(expect.objectContaining({ to: 'vrai@mail.com' }));
  });
});

describe('GET /api/gsr/auth/activate', () => {
  it('refuse un token inconnu', async () => {
    pool.query.mockResolvedValueOnce([[]]);
    const res = await request(app).get('/api/gsr/auth/activate').query({ token: 'inconnu' });
    expect(res.status).toBe(400);
  });

  it('applique le mot de passe en attente et marque l\'email confirmé', async () => {
    const future = new Date(Date.now() + 3600 * 1000);
    pool.query.mockResolvedValueOnce([[{ login: '217071K', pending_password_hash: 'hash', token_expires_at: future }]]);
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // update users.mdp
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // update account_registrations

    const res = await request(app).get('/api/gsr/auth/activate').query({ token: 'valide' });

    expect(res.status).toBe(200);
  });
});

describe('POST /api/gsr/auth/login', () => {
  it('refuse un mot de passe incorrect (ni en clair, ni en SHA1)', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'autrechose', Etat: 1, groupe: 13 }]]);

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'wrong' });

    expect(res.status).toBe(401);
  });

  it('accepte un mot de passe hérité stocké en clair', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'secret123', Etat: 1, groupe: 13 }]]);
    pool.query.mockResolvedValueOnce([[{ approved_at: new Date() }]]);
    pool.query.mockResolvedValue([[]]); // UPDATE last_connect, log, attachProfile : aucune photo

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(200);
    expect(typeof res.body.token).toBe('string');
    expect(res.body.user.hasPhoto).toBe(false);
  });

  it('accepte un mot de passe hérité stocké en SHA1', async () => {
    const crypto = require('crypto');
    const sha1 = crypto.createHash('sha1').update('secret123').digest('hex');
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: sha1, Etat: 1, groupe: 13 }]]);
    pool.query.mockResolvedValueOnce([[{ approved_at: new Date() }]]);
    pool.query.mockResolvedValue([[]]); // UPDATE last_connect, log, attachProfile

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(200);
  });

  it('refuse un compte dont Etat != 1', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'secret123', Etat: 0, groupe: 13 }]]);

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(403);
    expect(res.body.error).toMatch(/inactif/i);
  });

  it("refuse tant que l'accès gsr_app n'a pas été approuvé par un admin", async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'secret123', Etat: 1, groupe: 13 }]]);
    pool.query.mockResolvedValueOnce([[]]); // pas de ligne account_registrations approuvée

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(403);
    expect(res.body.error).toMatch(/validé/i);
  });

  it('renvoie un token JWT avec le rôle admin si groupe = 7', async () => {
    pool.query.mockResolvedValueOnce([[{
      login: '49491E', mdp: 'secret123', Etat: 1, groupe: 7,
      nom: 'YAMEOGO', prenom: 'SAMUEL', telephone: '0000', num_flotte: null,
      email: 'a@a.com', CODE_CDI: 'DGI-1', NOM_LONG_CDI: 'DIRECTION',
    }]]);
    pool.query.mockResolvedValueOnce([[{ approved_at: new Date() }]]);
    pool.query.mockResolvedValue([[]]); // UPDATE last_connect, log, attachProfile

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '49491E', password: 'secret123' });

    expect(res.status).toBe(200);
    expect(res.body.user.role).toBe('admin');
  });

  it('inclut le jeton Firebase quand la synchronisation réussit', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'secret123', Etat: 1, groupe: 13 }]]);
    pool.query.mockResolvedValueOnce([[{ approved_at: new Date() }]]);
    // UPDATE last_connect et log ne lisent pas leur résultat : seule la
    // requête user_profiles (attachProfile) doit renvoyer la photo.
    pool.query.mockImplementation((sql) =>
      Promise.resolve(
        String(sql).includes('user_profiles')
          ? [[{ photo_updated_at: new Date(), firebase_photo_url: 'https://x/y' }]]
          : [[]]
      )
    );
    firebase.createCustomToken.mockResolvedValueOnce('jeton-firebase');

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(200);
    expect(res.body.firebaseToken).toBe('jeton-firebase');
    expect(res.body.user.hasPhoto).toBe(true);
    expect(res.body.user.firebasePhotoUrl).toBe('https://x/y');
  });

  it("la connexion réussit même si la synchronisation Firebase échoue", async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', mdp: 'secret123', Etat: 1, groupe: 13 }]]);
    pool.query.mockResolvedValueOnce([[{ approved_at: new Date() }]]);
    pool.query.mockResolvedValue([[]]); // UPDATE last_connect, log, attachProfile
    firebase.createCustomToken.mockResolvedValueOnce(null);

    const res = await request(app).post('/api/gsr/auth/login').send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(200);
    expect(res.body.firebaseToken).toBeNull();
  });
});

describe('GET /api/gsr/auth/me', () => {
  it('refuse sans token', async () => {
    const res = await request(app).get('/api/gsr/auth/me');
    expect(res.status).toBe(401);
  });

  it("renvoie le profil de l'utilisateur authentifié", async () => {
    pool.query.mockResolvedValueOnce([[{
      login: '217071K', nom: 'OUEDRAOGO', prenom: 'LASSANE', telephone: '0000', num_flotte: null,
      email: 'a@a.com', CODE_CDI: 'DGI-2', NOM_LONG_CDI: 'DGI', groupe: 13, Etat: 1,
    }]]);

    pool.query.mockResolvedValue([[]]); // attachProfile

    const token = makeToken({ login: '217071K', role: 'agent' });
    const res = await request(app).get('/api/gsr/auth/me').set('Authorization', `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.login).toBe('217071K');
    expect(res.body.hasPhoto).toBe(false);
  });
});
