const logger = require('../utils/logger');

const KIMI_API_KEY = process.env.KIMI_API_KEY;
const KIMI_BASE_URL = process.env.KIMI_BASE_URL || 'https://api.moonshot.cn/v1';
const KIMI_MODEL = process.env.KIMI_MODEL || 'moonshot-v1-8k';

class AIService {
  async sendMessage(userMessage, history = []) {
    if (!KIMI_API_KEY) {
      throw new Error('🔑 KIMI_API_KEY not configured. Add it in Railway Variables.');
    }

    const messages = [
      { role: 'system', content: 'You are Echo, a helpful AI assistant. Respond in the same language as the user. Be concise and friendly.' },
      ...history.map(m => ({ role: m.sender === 'user' ? 'user' : 'assistant', content: m.content })),
      { role: 'user', content: userMessage },
    ];

    const response = await fetch(`${KIMI_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${KIMI_API_KEY}`,
      },
      body: JSON.stringify({ model: KIMI_MODEL, messages, temperature: 0.7, max_tokens: 2000 }),
    });

    if (!response.ok) {
      const err = await response.text();
      logger.error(`Kimi API error: ${response.status} — ${err}`);
      throw new Error(`AI service error: ${response.status}`);
    }

    const data = await response.json();
    return data.choices?.[0]?.message?.content || 'لم أفهم ذلك.';
  }
}

module.exports = new AIService();
