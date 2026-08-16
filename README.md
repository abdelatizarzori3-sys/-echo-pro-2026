# 🤖 Echo - Your Smart Assistant

## 🔑 Kimi API Key - Where to put it?

### ❌ NEVER put the key here:
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
```
railway.app → New Project
New → Database → PostgreSQL
New → GitHub Repo → Select Echo
Variables → KIMI_API_KEY = sk-your-key
Deploy!
```

### 2. Flutter
```bash
flutter pub get
flutter run
```

## 🏗️ Project Structure

```
Echo/
├── lib/              # Flutter app
├── backend/          # Node.js API
├── .github/          # CI/CD workflows
├── pubspec.yaml
└── README.md
```

## ⚠️ Security Warning

**Frontend → Backend → Kimi**
**NO key in Flutter ever!**
