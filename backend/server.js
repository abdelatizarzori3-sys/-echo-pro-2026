/**
 * Echo Backend Server
 * 🔑 KIMI_API_KEY must be set in Railway Variables ONLY
 */

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const { v4: uuidv4 } = require('uuid');
const winston = require('winston');
require('dotenv').config();

// Logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()],
});

// Env check
const DATABASE_URL = process.env.DATABASE_URL;
const KIMI_API_KEY = process.env.KIMI_API_KEY;
const KIMI_BASE_URL = process.env.KIMI_BASE_URL || 'https://api.moonshot.cn/v1';
const KIMI_MODEL = process.env.KIMI_MODEL || 'moonshot-v1-8k';
const PORT = process.env.PORT || 3000;

if (!DATABASE_URL) {
  logger.error('❌ DATABASE_URL is required');
  process.exit(1);
}

if (!KIMI_API_KEY) {
  logger.warn('⚠️  KIMI_API_KEY not set — AI chat will fail');
  logger.warn('   Add it in Railway Variables: KIMI_API_KEY');
  logger.warn('   Get free key: https://platform.moonshot.cn');
}

// Database
const pool = new Pool({
  connectionString: DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

// Init DB
pool.query(`
  CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    sender VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
  );
  CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(created_at ASC);
`).catch(console.error);

// App
const app = express();
app.use(helmet());
app.use(compression());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 30,
  message: { error: 'Too many requests' },
});
app.use('/api/', limiter);

// Routes
app.get('/', (req, res) => {
  res.json({ name: 'Echo Backend', version: '2.0.0', status: 'running' });
});

app.get('/api/health', async (req, res) => {
  const aiStatus = KIMI_API_KEY ? 'configured' : 'missing_key';
  res.json({
    status: 'up',
    services: { database: 'connected', ai: aiStatus },
    timestamp: new Date().toISOString(),
  });
});

app.get('/api/messages', async (req, res) => {
  const result = await pool.query(
    'SELECT * FROM messages ORDER BY created_at ASC'
  );
  res.json({ success: true, data: result.rows });
});

app.post('/api/chat', async (req, res) => {
  const { text } = req.body;
  if (!text || !text.trim()) {
    return res.status(400).json({ error: 'Text is required' });
  }

  // Save user message
  await pool.query(
    'INSERT INTO messages (id, content, sender) VALUES ($1, $2, $3)',
    [uuidv4(), text.trim(), 'user']
  );

  try {
    if (!KIMI_API_KEY) {
      throw new Error('KIMI_API_KEY not configured');
    }

    const response = await fetch(`${KIMI_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${KIMI_API_KEY}`, // 🔑 from Railway Variables
      },
      body: JSON.stringify({
        model: KIMI_MODEL,
        messages: [
          { role: 'system', content: 'You are Echo, a helpful AI assistant. Respond in the same language as the user.' },
          { role: 'user', content: text.trim() }
        ],
        temperature: 0.7,
        max_tokens: 2000,
      }),
    });

    const data = await response.json();
    const reply = data.choices?.[0]?.message?.content || 'لم أفهم ذلك.';

    // Save AI response
    const aiMsg = await pool.query(
      'INSERT INTO messages (id, content, sender) VALUES ($1, $2, $3) RETURNING *',
      [uuidv4(), reply, 'agent']
    );

    res.json({ success: true, data: { reply, message: aiMsg.rows[0] } });
  } catch (err) {
    logger.error('AI error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/messages', async (req, res) => {
  await pool.query('DELETE FROM messages');
  res.json({ success: true });
});

// Error handler
app.use((err, req, res, next) => {
  logger.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start
app.listen(PORT, () => {
  logger.info(`🚀 Echo Backend on port ${PORT}`);
  logger.info(`🔑 Kimi AI: ${KIMI_API_KEY ? 'ACTIVE' : 'MISSING — Set KIMI_API_KEY in Railway Variables'}`);
});
