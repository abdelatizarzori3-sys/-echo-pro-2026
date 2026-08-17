/**
 * Swagger Documentation Generator
 * Run: node src/scripts/swagger.js
 */
const fs = require('fs');
const path = require('path');
const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Echo Pro API',
      version: '3.0.0',
      description: 'AI-powered chat API with JWT auth, WebSocket, and Prisma ORM',
      contact: {
        name: 'Echo Pro Team',
        url: 'https://github.com/abdelatizarzori3-sys/Echo-pro',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      { url: 'http://localhost:3000/api', description: 'Local Development' },
      { url: 'https://echo-api.up.railway.app/api', description: 'Production' },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            email: { type: 'string', format: 'email' },
            name: { type: 'string', nullable: true },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        Session: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            title: { type: 'string', nullable: true },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        Message: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            content: { type: 'string' },
            sender: { type: 'string', enum: ['user', 'ai'] },
            sessionId: { type: 'string', format: 'uuid' },
            createdAt: { type: 'string', format: 'date-time' },
          },
        },
        Error: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: false },
            message: { type: 'string' },
            code: { type: 'string' },
          },
        },
      },
    },
  },
  apis: ['./src/routes/*.js'],
};

const specs = swaggerJsdoc(options);
const outputPath = path.join(__dirname, '../../swagger.json');
fs.writeFileSync(outputPath, JSON.stringify(specs, null, 2));
console.log('✅ Swagger docs generated:', outputPath);
