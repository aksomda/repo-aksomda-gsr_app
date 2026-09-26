jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const adminToken = makeToken({ login: '49491E', role: 'admin' });

function mockConnection() {
  const connection = {
    query: jest.fn(),
    beginTransaction: jest.fn().mockResolvedValue(),
    commit: jest.fn().mockResolvedValue(),
    rollback: jest.fn().mockResolvedValue(),
    release: jest.fn(),
  };
  pool.getConnection.mockResolvedValue(connection);
  return connection;
}

const validPayload = {
  room_id: 1,
  meeting_subject: 'Réunion budget',
  organizing_structure: 'DGB',
  date: '2026-09-20',
  start_time: '09:00',
  end_time: '10:00',
};

describe('POST /api/gsr/reservations', () => {
  it("refuse si l'heure de fin précède l'heure de début", async () => {
    const res = await request(app)
      .post('/api/gsr/reservations')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ ...validPayload, start_time: '10:00', end_time: '09:00' });

    expect(res.status).toBe(400);
  });

  it('refuse (409) si la salle est déjà réservée sur ce créneau', async () => {
    const connection = mockConnection();
    connection.query.mockResolvedValueOnce([[{ id: 99 }]]);

    const res = await request(app)
      .post('/api/gsr/reservations')
      .set('Authorization', `Bearer ${agentToken}`)
      .send(validPayload);

    expect(res.status).toBe(409);
    expect(connection.rollback).toHaveBeenCalled();
  });

  it('crée la réservation avec le login du demandeur si aucun chevauchement', async () => {
    const connection = mockConnection();
    connection.query.mockResolvedValueOnce([[]]);
    connection.query.mockResolvedValueOnce([{ insertId: 7 }]);

    const res = await request(app)
      .post('/api/gsr/reservations')
      .set('Authorization', `Bearer ${agentToken}`)
      .send(validPayload);

    expect(res.status).toBe(201);
    expect(connection.commit).toHaveBeenCalled();
    expect(connection.query.mock.calls[1][1]).toContain('217071K');
  });
});

describe('validation/rejet des réservations', () => {
  it('refuse un agent sur /validate', async () => {
    const res = await request(app)
      .post('/api/gsr/reservations/1/validate')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(403);
  });

  it('un admin peut valider une réservation en attente', async () => {
    pool.query.mockResolvedValueOnce([[{ id: 1, user_login: '217071K', meeting_subject: 'Réunion budget', date: '2026-09-20' }]]);

    const res = await request(app)
      .post('/api/gsr/reservations/1/validate')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
  });

  it('un admin peut rejeter une réservation avec un motif', async () => {
    pool.query.mockResolvedValueOnce([[{ id: 1, user_login: '217071K', meeting_subject: 'Réunion budget', date: '2026-09-20' }]]);

    const res = await request(app)
      .post('/api/gsr/reservations/1/reject')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ reason: 'Salle en maintenance' });

    expect(res.status).toBe(200);
  });
});

describe('Pagination des réservations', () => {
  const rows = (n) => Array.from({ length: n }, (_, i) => ({ id: i + 1, room_name: 'Salle A' }));

  it('renvoie la page demandée et signale qu\'il reste des résultats', async () => {
    pool.query.mockResolvedValueOnce([rows(3)]); // limit=2 => on lit 3 lignes

    const res = await request(app).get('/api/gsr/reservations/mine?limit=2&offset=4').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(2);
    expect(res.headers['x-has-more']).toBe('true');
    const [sql, params] = pool.query.mock.calls[0];
    expect(sql).toMatch(/LIMIT \? OFFSET \?/);
    expect(params.slice(-2)).toEqual([3, 4]);
  });

  it('dernière page : pas de page suivante', async () => {
    pool.query.mockResolvedValueOnce([rows(2)]);

    const res = await request(app).get('/api/gsr/reservations/mine?limit=2').set('Authorization', `Bearer ${agentToken}`);

    expect(res.body).toHaveLength(2);
    expect(res.headers['x-has-more']).toBe('false');
  });

  it('borne la taille de page (max 200) et ignore les valeurs invalides', async () => {
    pool.query.mockResolvedValueOnce([[]]);

    await request(app).get('/api/gsr/reservations/mine?limit=99999&offset=-5').set('Authorization', `Bearer ${agentToken}`);

    expect(pool.query.mock.calls[0][1].slice(-2)).toEqual([201, 0]);
  });

  it('la liste admin est paginée aussi, filtre de statut conservé', async () => {
    pool.query.mockResolvedValueOnce([rows(1)]);

    await request(app).get('/api/gsr/reservations?status=en_attente&limit=10').set('Authorization', `Bearer ${adminToken}`);

    const [, params] = pool.query.mock.calls[0];
    expect(params).toEqual(['en_attente', 11, 0]);
  });
});
