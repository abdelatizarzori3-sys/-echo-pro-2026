/**
 * AI Service — Kimi/Moonshot API Integration
 * 🔑 KIMI_API_KEY is read from Railway Variables ONLY
 * Never expose API keys in code or logs
 */

const env = require('../config/env');
const logger = require('../config/logger');

class AIService {
  constructor() {
    this.baseUrl = env.KIMI_BASE_URL;
    this.apiKey = env.KIMI_API_KEY;
    this.model = env.KIMI_MODEL;

    if (!this.apiKey) {
      logger.error('🔑 KIMI_API_KEY is not configured! AI features will fail.');
    }
  }

  async sendMessage(userMessage, history = []) {
    if (!this.apiKey) {
      throw new Error('AI service not configured. Set KIMI_API_KEY in Railway Variables.');
    }

    const messages = [
      { 
        role: 'system', 
        content: 'You are Echo, a helpful AI assistant. Respond in the same language as the user. Be concise and friendly.' 
      },
      ...history.map(msg => ({
        role: msg.sender === 'user' ? 'user' : 'assistant',
        content: msg.content
      })),
      { role: 'user', content: userMessage }
    ];

    try {
      const response = await fetch(`${this.baseUrl}/chat/completions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}` // 🔑 Secure — never logged
        },
        body: JSON.stringify({
          model: this.model,
          messages,
          temperature: 0.7,
          max_tokens: 2000,
          stream: false
        })
      });

      if (!response.ok) {
        const errorData = await response.text();
        logger.error(`Kimi API error: ${response.status} — ${errorData}`);
        throw new Error(`AI service error: ${response.status}`);
      }

      const data = await response.json();
      const reply = data.choices?.[0]?.message?.content;

      if (!reply) {
        throw new Error('Empty response from AI service');
      }

      logger.info('AI response generated successfully', { 
        model: this.model, 
        inputLength: userMessage.length,
        outputLength: reply.length 
      });

      return reply;

    } catch (error) {
      logger.error('AI service failed:', error.message);
      throw new Error('Failed to get AI response. Please try again.');
    }
  }

  // Health check for AI service
  async healthCheck() {
    if (!this.apiKey) return { status: 'missing_key', message: '🔑 KIMI_API_KEY not set' };
    try {
      const response = await fetch(`${this.baseUrl}/models`, {
        headers: { 'Authorization': `Bearer ${this.apiKey}` }
      });
      return { 
        status: response.ok ? 'healthy' : 'unhealthy', 
        statusCode: response.status 
      };
    } catch (e) {
      return { status: 'unreachable', error: e.message };
    }
  }
}

module.exports = new AIService();
