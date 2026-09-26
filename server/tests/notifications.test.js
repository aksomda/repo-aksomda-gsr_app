jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });

describe('GET /api/gsr/notifications', () => {
  it("retourne les notifications de l'utilisateur courant", async () => {
    pool.query.mockResolvedValueOnce([[
      { id: 1, user_login: '217071K', title: 'Réservation validée', is_read: 0 },
    ]]);

    const res = await request(app).get('/api/gsr/notifications').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
  });
});

describe('POST /api/gsr/notifications/:id/read', () => {
  it('renvoie 404 si la notification ne lui appartient pas', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 0 }]);

    const res = await request(app)
      .post('/api/gsr/notifications/1/read')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(404);
  });

  it('marque la notification comme lue', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/notifications/1/read')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
  });
});

describe('POST /api/gsr/fcm/token', () => {
  it('exige une authentification', async () => {
    const res = await request(app).post('/api/gsr/fcm/token').send({ token: 'abc' });
    expect(res.status).toBe(401);
  });

  it('refuse sans jeton', async () => {
    const res = await request(app)
      .post('/api/gsr/fcm/token')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({});

    expect(res.status).toBe(400);
  });

  it("enregistre le jeton pour l'utilisateur connecté", async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/fcm/token')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ token: 'fcm-abc', platform: 'android' });

    expect(res.status).toBe(200);
    const [sql, params] = pool.query.mock.calls[0];
    expect(sql).toMatch(/INSERT INTO fcm_tokens/);
    expect(params).toEqual(['217071K', 'fcm-abc', 'android']);
  });
});

describe('DELETE /api/gsr/fcm/token', () => {
  it("supprime le jeton, restreint au compte de l'appelant", async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .delete('/api/gsr/fcm/token')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ token: 'fcm-abc' });

    expect(res.status).toBe(200);
    expect(pool.query.mock.calls[0][1]).toEqual(['fcm-abc', '217071K']);
  });
});
