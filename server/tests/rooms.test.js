jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const adminToken = makeToken({ login: '49491E', role: 'admin' });

describe('GET /api/gsr/rooms', () => {
  it('ne renvoie que les salles non supprimées (del=0)', async () => {
    pool.query.mockResolvedValueOnce([[{ id: 1, name: 'Salle A', del: 0 }]]);

    const res = await request(app).get('/api/gsr/rooms').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(pool.query.mock.calls[0][0]).toMatch(/del = 0/);
  });
});

describe('GET /api/gsr/rooms/available', () => {
  it('rejette une requête sans les paramètres date/heure', async () => {
    const res = await request(app)
      .get('/api/gsr/rooms/available')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(400);
  });

  it("exclut les salles ayant une réservation qui chevauche le créneau", async () => {
    pool.query.mockResolvedValueOnce([[{ id: 1, name: 'Salle libre' }]]);

    const res = await request(app)
      .get('/api/gsr/rooms/available')
      .query({ date: '2026-09-20', start_time: '09:00', end_time: '10:00' })
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toEqual([{ id: 1, name: 'Salle libre' }]);
  });
});

describe('POST /api/gsr/rooms/save', () => {
  it('refuse un agent (réservé aux admins)', async () => {
    const res = await request(app)
      .post('/api/gsr/rooms/save')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ name: 'Salle A' });

    expect(res.status).toBe(403);
  });

  it('autorise un admin à créer une salle avec les colonnes réelles', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 10 }]);

    const res = await request(app)
      .post('/api/gsr/rooms/save')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: 'Salle A', hasComputer: true, computerCount: 2,
        category_room_id: 1, structure_code: 'DGI-2', rentalAmount: 0, status: 1,
      });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
  });
});

describe('POST /api/gsr/rooms/delete', () => {
  it('effectue une suppression logique (del=1), pas un DELETE', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .post('/api/gsr/rooms/delete')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ id: 1 });

    expect(res.status).toBe(200);
    expect(pool.query.mock.calls[0][0]).toMatch(/UPDATE room SET del = 1/);
  });
});

describe('POST /api/gsr/rooms/save (localisation)', () => {
  it('enregistre region_name/province_name/city_name/location', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 11 }]);

    await request(app)
      .post('/api/gsr/rooms/save')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: 'Salle B', hasComputer: false, computerCount: 0, category_room_id: 1, rentalAmount: 0, status: 1,
        region_name: 'Centre', province_name: 'Kadiogo', city_name: 'Ouagadougou', location: 'Siège',
      });

    const [sql, params] = pool.query.mock.calls[0];
    expect(sql).toMatch(/region_name, province_name, city_name, location/);
    expect(params).toEqual(expect.arrayContaining(['Centre', 'Kadiogo', 'Ouagadougou', 'Siège']));
    expect((sql.match(/\?/g) || []).length).toBe(params.length);
  });
});
