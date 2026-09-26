jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');

describe('GET /api/gsr/health', () => {
  it('répond ok quand la base est joignable (sans authentification)', async () => {
    pool.query.mockResolvedValueOnce([[{ 1: 1 }]]);

    const res = await request(app).get('/api/gsr/health');

    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok', database: true });
  });

  it('répond 503 quand la base est injoignable', async () => {
    pool.query.mockRejectedValueOnce(new Error('ECONNREFUSED'));

    const res = await request(app).get('/api/gsr/health');

    expect(res.status).toBe(503);
    expect(res.body.database).toBe(false);
  });

  it("n'est pas journalisée dans activity_logs", async () => {
    pool.query.mockResolvedValueOnce([[{ 1: 1 }]]);
    pool.query.mockClear();
    pool.query.mockResolvedValueOnce([[{ 1: 1 }]]);

    await request(app).get('/api/gsr/health');
    await new Promise((r) => setImmediate(r));

    expect(pool.query.mock.calls.every(([sql]) => !/activity_logs/.test(sql))).toBe(true);
  });
});
