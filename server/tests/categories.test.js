jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const adminToken = makeToken({ login: '49491E', role: 'admin' });

describe('GET /api/gsr/categories', () => {
  it('est accessible à tout utilisateur authentifié et filtre del=0', async () => {
    pool.query.mockResolvedValueOnce([[
      { id: 1, libelle_cat: 'GRATUIT', montant_location: 0, actif: 1, del: 0 },
      { id: 2, libelle_cat: 'LOCATION', montant_location: 50000, actif: 1, del: 0 },
    ]]);

    const res = await request(app).get('/api/gsr/categories').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
    expect(pool.query.mock.calls[0][0]).toMatch(/del = 0/);
  });
});

describe('POST /api/gsr/categories/save', () => {
  it('refuse un agent', async () => {
    const res = await request(app)
      .post('/api/gsr/categories/save')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ libelle_cat: 'GRATUIT' });

    expect(res.status).toBe(403);
  });

  it('crée une catégorie (admin)', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 5 }]);

    const res = await request(app)
      .post('/api/gsr/categories/save')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ libelle_cat: 'GRATUIT', montant_location: 0, actif: true });

    expect(res.status).toBe(200);
  });
});

describe('POST /api/gsr/categories/delete', () => {
  it('effectue une suppression logique (del=1)', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/categories/delete')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ id: 1 });

    expect(res.status).toBe(200);
    expect(pool.query.mock.calls[0][0]).toMatch(/UPDATE category_room SET del = 1/);
  });
});
