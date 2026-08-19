/**
 * Integration Tests for API
 */

const request = require('supertest');
const app = require('../src/app');

describe('Authentication Integration Tests', () => {
  test('POST /api/auth/register should create user', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test@example.com',
        password: 'TestPassword123',
        name: 'Test User',
      })
      .expect(201);

    expect(response.body.token).toBeDefined();
  });

  test('POST /api/auth/login should return token', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'TestPassword123',
      })
      .expect(200);

    expect(response.body.token).toBeDefined();
  });
});

describe('Rate Limiting Tests', () => {
  test('Should rate limit after 5 auth attempts', async () => {
    for (let i = 0; i < 5; i++) {
      await request(app)
        .post('/api/auth/login')
        .send({ email: 'test@test.com', password: 'wrong' });
    }

    const response = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@test.com', password: 'wrong' })
      .expect(429);

    expect(response.body.message).toContain('Too many');
  });
});
