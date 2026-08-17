/**
 * Kimi AI Service — Production Grade
 * Handles streaming, retries, error recovery, and token management
 */
const axios = require('axios');
const logger = require('../utils/logger');

class KimiService {
  constructor() {
    this.apiKey = process.env.KIMI_API_KEY;
    this.baseUrl = process.env.KIMI_BASE_URL || 'https://api.moonshot.cn/v1';
    this.model = process.env.KIMI_MODEL || 'moonshot-v1-8k';
    this.maxRetries = 3;
    this.retryDelay = 1000;

    if (!this.apiKey) {
      logger.error('❌ KIMI_API_KEY not set! AI features will fail.');
    }
  }

  async generateResponse(messages, options = {}) {
    const {
      model = this.model,
      temperature = 0.7,
      maxTokens = 2048,
      stream = false,
    } = options;

    let lastError;
    for (let attempt = 1; attempt <= this.maxRetries; attempt++) {
      try {
        logger.info(`🤖 Kimi request (attempt ${attempt}/${this.maxRetries})`);

        const response = await axios.post(
          `${this.baseUrl}/chat/completions`,
          {
            model,
            messages: messages.map((m) => ({
              role: m.role || 'user',
              content: m.content,
            })),
            temperature,
            max_tokens: maxTokens,
            stream,
          },
          {
            headers: {
              Authorization: `Bearer ${this.apiKey}`,
              'Content-Type': 'application/json',
            },
            timeout: 30000,
          }
        );

        const content = response.data.choices[0]?.message?.content;
        const usage = response.data.usage;

        logger.info(`✅ Kimi response | Tokens: ${usage?.total_tokens || 'N/A'}`);

        return {
          success: true,
          content,
          usage,
          model: response.data.model,
        };
      } catch (error) {
        lastError = error;
        const isRetryable =
          error.code === 'ECONNRESET' ||
          error.code === 'ETIMEDOUT' ||
          error.response?.status === 429 ||
          error.response?.status >= 500;

        if (!isRetryable || attempt === this.maxRetries) break;

        const delay = this.retryDelay * Math.pow(2, attempt - 1);
        logger.warn(`⏳ Retrying in ${delay}ms... (${error.message})`);
        await new Promise((resolve) => setTimeout(resolve, delay));
      }
    }

    logger.error('❌ Kimi failed:', lastError.message);
    return {
      success: false,
      content: "I'm having trouble connecting. Please try again.",
      error: lastError.message,
      fallback: true,
    };
  }

  async *streamResponse(messages, options = {}) {
    const {
      model = this.model,
      temperature = 0.7,
      maxTokens = 2048,
    } = options;

    const response = await axios.post(
      `${this.baseUrl}/chat/completions`,
      {
        model,
        messages: messages.map((m) => ({ role: m.role || 'user', content: m.content })),
        temperature,
        max_tokens: maxTokens,
        stream: true,
      },
      {
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json',
        },
        responseType: 'stream',
        timeout: 60000,
      }
    );

    let buffer = '';
    for await (const chunk of response.data) {
      buffer += chunk.toString();
      const lines = buffer.split('\n');
      buffer = lines.pop();

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data === '[DONE]') return;
          try {
            const parsed = JSON.parse(data);
            const content = parsed.choices[0]?.delta?.content;
            if (content) yield content;
          } catch { /* ignore */ }
        }
      }
    }
  }

  async healthCheck() {
    try {
      await axios.get(`${this.baseUrl}/models`, {
        headers: { Authorization: `Bearer ${this.apiKey}` },
        timeout: 5000,
      });
      return { status: 'healthy', model: this.model };
    } catch (error) {
      return { status: 'unhealthy', error: error.message };
    }
  }
}

module.exports = new KimiService();
