const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

router.get('/', async (req, res) => {
  const db = await prisma.$queryRaw`SELECT 1`.then(() => 'connected').catch(() => 'error');
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    services: { database: db, ai: process.env.KIMI_API_KEY ? 'configured' : 'missing' },
    uptime: process.uptime(),
  });
});

module.exports = router;
