jest.mock('../config/db');

const request = require('supertest');
const pool = require('../config/db');
const app = require('../app');
const { makeToken } = require('./helpers');

describe('GET /api/gsr/structures', () => {
  it("est accessible sans authentification (formulaire d'inscription)", async () => {
    pool.query.mockResolvedValueOnce([[
      { code_cdi: 'DGI-2', libelle_long_cdi: 'DIRECTION GÉNÉRALE DES IMPÔTS', localite_cdi: 'OUAGADOUGOU' },
    ]]);

    const res = await request(app).get('/api/gsr/structures');

    expect(res.status).toBe(200);
    expect(res.body).toHaveLength(1);
    expect(res.body[0].code_cdi).toBe('DGI-2');
  });

  it('interroge les vraies colonnes MAJUSCULES de ref_structure avec un alias', async () => {
    pool.query.mockResolvedValueOnce([[]]);
    await request(app).get('/api/gsr/structures');

    expect(pool.query.mock.calls[0][0]).toMatch(/CODE_CDI AS code_cdi/);
  });
});

describe('GET /api/gsr/directions-regionales', () => {
  const agentToken = makeToken({ login: '217071K', role: 'agent' });

  it('exige une authentification', async () => {
    const res = await request(app).get('/api/gsr/directions-regionales');
    expect(res.status).toBe(401);
  });

  it('ne renvoie que les directions régionales des impôts de ref_structure', async () => {
    pool.query.mockResolvedValueOnce([[
      { code_cdi: 'DGI-4', libelle_long_cdi: 'DIRECTION RÉGIONALE DES IMPÔTS DU CENTRE', localite_cdi: 'OUAGADOUGOU' },
    ]]);

    const res = await request(app).get('/api/gsr/directions-regionales').set('Authorization', `Bearer ${agentToken}`);

    expect(res.status).toBe(200);
    expect(res.body[0].code_cdi).toBe('DGI-4');
    expect(pool.query.mock.calls[0][0]).toMatch(/FROM ref_structure/);
    expect(pool.query.mock.calls[0][0]).toMatch(/LIKE 'DIRECTION RÉGIONALE DES IMPÔTS%'/);
  });
});
