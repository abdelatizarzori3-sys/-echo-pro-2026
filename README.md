# 🤖 Echo Pro v3.0 — Your Smart Assistant

## 🔑 Kimi API Key — Where to put it?

### ❌ NEVER:
- Flutter code (exposed in APK/IPA)
- GitHub (stolen immediately)
- Any file inside `lib/`

### ✅ ONLY correct place:
```
Railway Dashboard → Your Project → Variables → KIMI_API_KEY
```

### 🔑 Get free key:
https://platform.moonshot.cn → API Keys → Create

## 🚀 Quick Start

### 1. Railway (Backend + Database)
```bash
# Railway CLI
railway login
railway init
railway add --database postgres

# Set variables
railway variables set KIMI_API_KEY=sk-your-key
railway variables set JWT_SECRET=your-secret-32-chars-long

# Deploy
railway up
```

### 2. Flutter
```bash
flutter pub get
flutter run
```

## 🏗️ Architecture

```
Clean Architecture + BLoC + Prisma + JWT
├── lib/
│   ├── core/          # Theme, Network, DI, Utils
│   ├── features/
│   │   ├── auth/      # Login, Register, JWT
│   │   └── chat/      # Messages, Sessions, AI
│   └── main.dart
├── backend/
│   ├── src/
│   │   ├── config/    # Swagger, Prisma
│   │   ├── controllers/
│   │   ├── middleware/# Auth, Rate Limit, Error
│   │   ├── routes/
│   │   ├── services/  # AI Service (Kimi)
│   │   ├── websocket/ # Real-time chat
│   │   └── jobs/      # Cron cleanup
│   └── prisma/
│       └── schema.prisma
└── .github/workflows/
    ├── flutter.yml
    └── backend.yml
```

## 🛡️ Security Features

| Feature | Implementation |
|---------|---------------|
| Auth | JWT + bcrypt |
| Rate Limit | 20 msg/min per user |
| Input Validation | express-validator + Joi |
| Headers | Helmet |
| CORS | Configurable |
| API Keys | Railway Variables only |
| Logging | Winston + Daily Rotate |
| Monitoring | Sentry |

## 📊 Monitoring

- **Sentry**: Error tracking
- **Railway Logs**: Real-time
- **Health Check**: `/api/health`
- **Swagger Docs**: `/api/docs`

## 🧪 Testing

```bash
# Backend
cd backend
npm test

# Flutter
cd ..
flutter test
```
