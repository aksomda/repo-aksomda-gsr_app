const { productionConfigProblems, corsOrigin } = require('../config/security');

const goodEnv = {
  NODE_ENV: 'production',
  JWT_SECRET: 'k9Jx2mQ7vB4nR8tY1wZ6cD3fG5hL0pAs',
  ALLOWED_ORIGIN: 'https://gsr.example.bf',
  APP_BASE_URL: 'https://api.example.bf',
};

describe('productionConfigProblems', () => {
  it('ne bloque rien en développement', () => {
    expect(productionConfigProblems({ NODE_ENV: 'development' })).toEqual([]);
    expect(productionConfigProblems({})).toEqual([]);
  });

  it('accepte une configuration de production correcte', () => {
    expect(productionConfigProblems(goodEnv)).toEqual([]);
  });

  it("refuse un secret JWT trop court ou resté à la valeur d'exemple", () => {
    expect(productionConfigProblems({ ...goodEnv, JWT_SECRET: 'court' })).toHaveLength(1);
    expect(productionConfigProblems({ ...goodEnv, JWT_SECRET: 'change_me_to_a_long_random_string' })).toHaveLength(1);
    expect(productionConfigProblems({ ...goodEnv, JWT_SECRET: 'dev-only-change-me-1f9a3c7e2b6d4f80a1c5e9d3b7f2046c' })).toHaveLength(1);
  });

  it('exige des origines CORS et une URL publique https', () => {
    expect(productionConfigProblems({ ...goodEnv, ALLOWED_ORIGIN: '' })).toHaveLength(1);
    expect(productionConfigProblems({ ...goodEnv, APP_BASE_URL: 'http://localhost:3000' })).toHaveLength(1);
  });
});

describe('corsOrigin', () => {
  it('reste ouvert en développement, fermé en production sans origine', () => {
    expect(corsOrigin({})).toBe('*');
    expect(corsOrigin({ NODE_ENV: 'production' })).toBe(false);
  });

  it('utilise la liste explicite quand elle est fournie', () => {
    expect(corsOrigin({ ALLOWED_ORIGIN: 'https://a.bf, https://b.bf' })).toEqual(['https://a.bf', 'https://b.bf']);
  });
});
