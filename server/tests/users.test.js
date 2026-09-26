jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const adminToken = makeToken({ login: '49491E', role: 'admin' });

describe('Gestion des accès gsr_app (admin uniquement)', () => {
  it('GET /users refuse un agent', async () => {
    const res = await request(app).get('/api/gsr/users').set('Authorization', `Bearer ${agentToken}`);
    expect(res.status).toBe(403);
  });

  it('GET /users liste les demandes en attente de validation', async () => {
    pool.query.mockResolvedValueOnce([[
      { login: '217071K', nom: 'OUEDRAOGO', prenom: 'LASSANE', groupe: 13, Etat: 1, CODE_CDI: 'DGI-2', NOM_LONG_CDI: 'DGI' },
    ]]);

    const res = await request(app).get('/api/gsr/users').set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0].login).toBe('217071K');
  });

  it('POST /users/:login/approve valide un accès', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/users/217071K/approve')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
  });

  it('POST /users/:login/approve renvoie 404 si aucune demande', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 0 }]);

    const res = await request(app)
      .post('/api/gsr/users/INCONNU/approve')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(404);
  });

  it('POST /users/:login/reject rejette une demande', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/users/217071K/reject')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
  });

  it('POST /users/activate-direct refuse un login inconnu', async () => {
    pool.query.mockResolvedValueOnce([[]]);

    const res = await request(app)
      .post('/api/gsr/users/activate-direct')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ login: 'INCONNU', password: 'secret123' });

    expect(res.status).toBe(404);
  });

  it('POST /users/activate-direct active un agent existant sans email', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K' }]]);
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // update users.mdp
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // upsert account_registrations

    const res = await request(app)
      .post('/api/gsr/users/activate-direct')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ login: '217071K', password: 'secret123' });

    expect(res.status).toBe(201);
  });

  it('POST /users/:login/reset-password génère un mot de passe temporaire', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/users/217071K/reset-password')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(typeof res.body.temporaryPassword).toBe('string');
  });
});
