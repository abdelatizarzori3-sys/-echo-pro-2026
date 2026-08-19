# 📋 Environment Setup

## Variables Required

### Backend
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@localhost:5432/echo
KIMI_API_KEY=sk-your-key-here
JWT_SECRET=your-secret-key-32-chars-long
CORS_ORIGIN=*
REDIS_URL=redis://localhost:6379
SENTRY_DSN=https://your-sentry-dsn
```

### Flutter
```env
API_BASE_URL=http://localhost:3000/api
WEBSOCKET_URL=ws://localhost:3000
SENTRY_DSN=https://your-sentry-dsn
```

## Setup Instructions

1. Copy `.env.example` to `.env`
2. Fill in your API keys
3. Run migrations
4. Start the server

## Security Notes

- ✅ Never commit `.env` files
- ✅ Use environment variables for secrets
- ✅ Rotate keys regularly
- ✅ Use HTTPS in production
