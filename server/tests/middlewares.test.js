jest.mock('../config/db');

const request = require('supertest');
const app = require('../app');
const { makeToken } = require('./helpers');

describe('authenticate middleware', () => {
  it("refuse une requête sans en-tête Authorization", async () => {
    const res = await request(app).get('/api/gsr/rooms');
    expect(res.status).toBe(401);
  });

  it('refuse un token invalide', async () => {
    const res = await request(app).get('/api/gsr/rooms').set('Authorization', 'Bearer not-a-real-token');
    expect(res.status).toBe(401);
  });

  it('accepte un token valide', async () => {
    const pool = require('../config/db');
    pool.query.mockResolvedValueOnce([[]]);

    const token = makeToken({ login: '217071K', role: 'agent' });
    const res = await request(app).get('/api/gsr/rooms').set('Authorization', `Bearer ${token}`);

    expect(res.status).toBe(200);
  });
});

describe('requireRole middleware', () => {
  it('refuse un agent sur une route réservée aux admins', async () => {
    const token = makeToken({ login: '217071K', role: 'agent' });
    const res = await request(app)
      .post('/api/gsr/rooms/save')
      .set('Authorization', `Bearer ${token}`)
      .send({ name: 'Salle A' });

    expect(res.status).toBe(403);
  });
});
