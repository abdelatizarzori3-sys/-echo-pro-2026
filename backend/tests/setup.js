// Test setup
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-secret-32-chars-long!!!!';
process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/echo_test';
