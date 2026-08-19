/**
 * Kimi AI Service Integration
 */

const axios = require('axios');
const env = require('../config/env');
const logger = require('../config/logger');

class KimiService {
  constructor() {
    this.client = axios.create({
      baseURL: env.KIMI_BASE_URL,
      headers: {
        Authorization: `Bearer ${env.KIMI_API_KEY}`,
        'Content-Type': 'application/json',
      },
    });
  }

  async chat(message, conversationHistory = []) {
    try {
      const response = await this.client.post('/chat/completions', {
        model: env.KIMI_MODEL,
        messages: [
          ...conversationHistory,
          { role: 'user', content: message },
        ],
        temperature: 0.7,
        max_tokens: 1024,
      });

      return response.data.choices[0].message.content;
    } catch (error) {
      logger.error('Kimi API Error:', error.message);
      throw new Error('Failed to get AI response');
    }
  }

  async generateTitle(content) {
    const response = await this.chat(
      `Generate a short title (max 50 chars) for this conversation: "${content.substring(0, 100)}"`,
      []
    );
    return response.trim().substring(0, 50);
  }
}

module.exports = new KimiService();
