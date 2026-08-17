/**
 * Chat Service — Business Logic Layer
 * Handles database operations for messages
 */

const { pool } = require('../config/database');
const logger = require('../config/logger');
const { v4: uuidv4 } = require('uuid');

class ChatService {
  async getMessages(sessionId = 'default', limit = 50, offset = 0) {
    const result = await pool.query(
      `SELECT * FROM messages 
       WHERE session_id = $1 
       ORDER BY created_at ASC 
       LIMIT $2 OFFSET $3`,
      [sessionId, limit, offset]
    );
    return result.rows;
  }

  async saveMessage(content, sender, sessionId = 'default', metadata = {}) {
    const result = await pool.query(
      `INSERT INTO messages (id, content, sender, session_id, metadata) 
       VALUES ($1, $2, $3, $4, $5) 
       RETURNING *`,
      [uuidv4(), content, sender, sessionId, JSON.stringify(metadata)]
    );

    // Update session last_active
    await pool.query(
      `INSERT INTO sessions (id, last_active) 
       VALUES ($1, CURRENT_TIMESTAMP)
       ON CONFLICT (id) DO UPDATE SET last_active = CURRENT_TIMESTAMP`,
      [sessionId]
    );

    return result.rows[0];
  }

  async clearSession(sessionId = 'default') {
    await pool.query('DELETE FROM messages WHERE session_id = $1', [sessionId]);
    logger.info(`Session ${sessionId} cleared`);
    return { success: true };
  }

  async getRecentHistory(sessionId = 'default', limit = 10) {
    const result = await pool.query(
      `SELECT content, sender FROM messages 
       WHERE session_id = $1 AND sender IN ('user', 'agent')
       ORDER BY created_at DESC 
       LIMIT $2`,
      [sessionId, limit]
    );
    return result.rows.reverse();
  }

  async getStats() {
    const result = await pool.query(`
      SELECT 
        COUNT(*) as total_messages,
        COUNT(DISTINCT session_id) as total_sessions,
        COUNT(*) FILTER (WHERE sender = 'user') as user_messages,
        COUNT(*) FILTER (WHERE sender = 'agent') as ai_messages
      FROM messages
    `);
    return result.rows[0];
  }
}

module.exports = new ChatService();
