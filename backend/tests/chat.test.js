const request = require('supertest');
const app = require('../src/app');

describe('Chat API', () => {
  test('GET /api/health - returns status', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('healthy');
  });

  test('GET /api/chat/messages without auth - returns 401', async () => {
    const res = await request(app).get('/api/chat/messages');
    expect(res.statusCode).toBe(401);
  });
});
