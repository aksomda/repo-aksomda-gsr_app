jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const adminToken = makeToken({ login: '49491E', role: 'admin' });

describe('POST /api/gsr/messages', () => {
  it('refuse un message vide', async () => {
    const res = await request(app)
      .post('/api/gsr/messages')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ content: '   ' });

    expect(res.status).toBe(400);
  });

  it("un agent envoie un message à l'administration (notifie tous les admins)", async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 1 }]); // insert message
    pool.query.mockResolvedValueOnce([[{ login: '49491E' }, { login: '55759X' }]]); // liste des admins

    const res = await request(app)
      .post('/api/gsr/messages')
      .set('Authorization', `Bearer ${agentToken}`)
      .send({ content: 'Bonjour, la salle A est fermée.' });

    expect(res.status).toBe(201);
  });

  it('un admin doit préciser un destinataire', async () => {
    const res = await request(app)
      .post('/api/gsr/messages')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ content: 'Réponse' });

    expect(res.status).toBe(400);
  });
});

describe('GET /api/gsr/messages', () => {
  it("refuse un admin sans le paramètre 'with'", async () => {
    const res = await request(app).get('/api/gsr/messages').set('Authorization', `Bearer ${adminToken}`);
    expect(res.status).toBe(400);
  });

  it('retourne la conversation d’un agent avec l’administration', async () => {
    pool.query.mockResolvedValueOnce([[{ id: 1, sender_login: '217071K', recipient_login: null, content: 'Bonjour' }]]);

    const res = await request(app).get('/api/gsr/messages').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
  });
});

describe('GET /api/gsr/messages/recipients', () => {
  it('est réservé aux admins', async () => {
    const res = await request(app).get('/api/gsr/messages/recipients').set('Authorization', `Bearer ${agentToken}`);
    expect(res.status).toBe(403);
  });

  it('liste les agents validés (hors admins)', async () => {
    pool.query.mockResolvedValueOnce([[{ login: '217071K', nom: 'OUEDRAOGO', prenom: 'Awa' }]]);

    const res = await request(app).get('/api/gsr/messages/recipients').set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(res.body[0].login).toBe('217071K');
    expect(pool.query.mock.calls[0][0]).toMatch(/approved_at IS NOT NULL/);
    expect(pool.query.mock.calls[0][0]).toMatch(/groupe != 7/);
  });
});
