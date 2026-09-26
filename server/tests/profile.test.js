jest.mock('../config/db');
jest.mock('../config/firebase', () => ({
  uploadPhoto: jest.fn().mockResolvedValue(null),
  deletePhoto: jest.fn().mockResolvedValue(),
}));

const request = require('supertest');
const pool = require('../config/db');
const firebase = require('../config/firebase');
const app = require('../app');
const { makeToken } = require('./helpers');

const agentToken = makeToken({ login: '217071K', role: 'agent' });
const otherAgentToken = makeToken({ login: '300000Z', role: 'agent' });

describe('GET /api/gsr/profile/photo/:login', () => {
  it('exige une authentification', async () => {
    const res = await request(app).get('/api/gsr/profile/photo/217071K');
    expect(res.status).toBe(401);
  });

  it("renvoie 404 si l'utilisateur n'a pas de photo", async () => {
    pool.query.mockResolvedValueOnce([[]]);

    const res = await request(app)
      .get('/api/gsr/profile/photo/217071K')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(404);
  });

  it("un autre agent authentifié peut voir la photo (annuaire)", async () => {
    pool.query.mockResolvedValueOnce([[{ photo_blob: Buffer.from('img'), photo_content_type: 'image/png' }]]);

    const res = await request(app)
      .get('/api/gsr/profile/photo/217071K')
      .set('Authorization', `Bearer ${otherAgentToken}`);

    expect(res.status).toBe(200);
    expect(res.headers['content-type']).toBe('image/png');
    expect(res.body).toEqual(Buffer.from('img'));
  });
});

describe('POST /api/gsr/profile/photo', () => {
  it('refuse sans fichier', async () => {
    const res = await request(app)
      .post('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(400);
  });

  it('refuse un type de fichier non autorisé', async () => {
    const res = await request(app)
      .post('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`)
      .attach('photo', Buffer.from('%PDF-1.4'), { filename: 'x.pdf', contentType: 'application/pdf' });

    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/JPEG, PNG, WEBP/);
  });

  it('refuse un fichier de plus de 5 Mo', async () => {
    const big = Buffer.alloc(5 * 1024 * 1024 + 1);
    const res = await request(app)
      .post('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`)
      .attach('photo', big, { filename: 'x.png', contentType: 'image/png' });

    expect(res.status).toBe(400);
    expect(res.body.error).toMatch(/volumineuse/);
  });

  it('enregistre la photo en MySQL (source principale) même si Firebase échoue', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // INSERT ... ON DUPLICATE KEY
    firebase.uploadPhoto.mockResolvedValueOnce(null);

    const res = await request(app)
      .post('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`)
      .attach('photo', Buffer.from('img-bytes'), { filename: 'moi.png', contentType: 'image/png' });

    expect(res.status).toBe(200);
    expect(res.body.firebaseSynced).toBe(false);
    const [sql, params] = pool.query.mock.calls[0];
    expect(sql).toMatch(/INSERT INTO user_profiles/);
    expect(params[0]).toBe('217071K'); // le login vient du jeton, jamais du corps de la requête
    expect(Buffer.isBuffer(params[1])).toBe(true);
  });

  it('synchronise vers Firebase Storage quand disponible (miroir best effort)', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // INSERT
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // UPDATE firebase_photo_url
    firebase.uploadPhoto.mockResolvedValueOnce('https://storage.googleapis.com/gsr-app/profile-photos/217071K');

    const res = await request(app)
      .post('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`)
      .attach('photo', Buffer.from('img-bytes'), { filename: 'moi.png', contentType: 'image/png' });

    expect(res.status).toBe(200);
    expect(res.body.firebaseSynced).toBe(true);
    expect(pool.query.mock.calls[1][0]).toMatch(/UPDATE user_profiles SET firebase_photo_url/);
  });
});

describe('DELETE /api/gsr/profile/photo', () => {
  it('efface la photo côté MySQL et Firebase, pour le compte connecté uniquement', async () => {
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]);

    const res = await request(app)
      .delete('/api/gsr/profile/photo')
      .set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(pool.query.mock.calls[0][1]).toEqual(['217071K']);
    expect(firebase.deletePhoto).toHaveBeenCalledWith('217071K');
  });
});
