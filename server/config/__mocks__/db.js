// Mock manuel du pool mysql2 utilisé par tous les tests (jest.mock('../config/db')).
module.exports = {
  query: jest.fn(),
  getConnection: jest.fn(),
};
