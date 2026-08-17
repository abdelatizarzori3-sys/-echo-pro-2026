# 🚀 Echo Pro — دليل النشر الكامل

## 📋 متطلبات ما قبل النشر

### Backend
- Node.js >= 20.0.0
- PostgreSQL 14+
- Redis 7+ (اختياري لكن موصى به)
- حساب Railway (أو VPS)

### Flutter
- Flutter SDK >= 3.4.0
- Android SDK / Xcode
- حساب Google Play Console / Apple Developer

---

## 🗄️ الخطوة 1: إعداد قاعدة البيانات

### PostgreSQL محلياً (للتطوير)
```bash
docker-compose up postgres -d
```

### Railway (للإنتاج)
```bash
railway login
railway init
railway add --database postgres
```

### إنشاء الجداول
```bash
cd backend
npx prisma migrate dev --name init
npx prisma db seed
```

---

## 🔧 الخطوة 2: إعداد متغيرات البيئة

### Backend — `.env`
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@host:5432/dbname
KIMI_API_KEY=sk-your-moonshot-api-key
KIMI_BASE_URL=https://api.moonshot.cn/v1
KIMI_MODEL=moonshot-v1-8k
JWT_SECRET=your-super-secret-32-chars-long
CORS_ORIGIN=https://your-domain.com
LOG_LEVEL=info
```

### Flutter — `.env`
```env
API_BASE_URL=https://your-backend-url.com/api
WEBSOCKET_URL=wss://your-backend-url.com
SENTRY_DSN=your-sentry-dsn
```

---

## 🐳 الخطوة 3: نشر Backend

### Docker Compose (محلي)
```bash
docker-compose up --build -d
```

### Railway (إنتاج)
```bash
railway login
railway link
railway up
```

### Render (بديل)
1. أنشئ Web Service جديد
2. اربط مستودع GitHub
3. اضبط:
   - Build Command: `npm install && npx prisma generate && npx prisma migrate deploy`
   - Start Command: `node src/server.js`
4. أضف متغيرات البيئة

---

## 📱 الخطوة 4: بناء Flutter

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (لـ Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🔐 الخطوة 5: الأمان

### إلزامي قبل النشر:
- [ ] تغيير JWT_SECRET (32+ حرف عشوائي)
- [ ] إخفاء KIMI_API_KEY في متغيرات البيئة
- [ ] تفعيل HTTPS
- [ ] تفعيل Rate Limiting
- [ ] إعداد Sentry للمراقبة
- [ ] تفعيل Helmet headers
- [ ] مراجعة CORS origins

### إنشاء مفتاح JWT آمن:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## 📊 الخطوة 6: المراقبة

### Sentry
1. أنشئ مشروع في [sentry.io](https://sentry.io)
2. انسخ DSN
3. أضفه في:
   - Backend: `SENTRY_DSN`
   - Flutter: `SENTRY_DSN`

### Railway Logs
```bash
railway logs
```

### Health Check
```bash
curl https://your-api.com/api/health
```

---

## 🔄 الخطوة 7: CI/CD

### GitHub Actions
تم تضمين workflows جاهزة:
- `.github/workflows/backend.yml` — بناء واختبار Backend
- `.github/workflows/flutter.yml` — بناء واختبار Flutter

### الإعداد:
1. أضف secrets في GitHub:
   - `RAILWAY_TOKEN`
   - `KIMI_API_KEY`
   - `JWT_SECRET`

---

## 🛠️ استكشاف الأخطاء

### قاعدة البيانات لا تتصل
```bash
# تحقق من URL
npx prisma validate

# اختبر الاتصال
npx prisma db pull
```

### Kimi API لا يعمل
```bash
# تحقق من المفتاح
curl -H "Authorization: Bearer $KIMI_API_KEY"   https://api.moonshot.cn/v1/models
```

### Flutter لا يتصل بالـ Backend
```bash
# تحقق من CORS
curl -I -X OPTIONS   -H "Origin: http://localhost"   https://your-api.com/api/health
```

---

## 📞 دعم

- GitHub Issues: [Echo-pro](https://github.com/abdelatizarzori3-sys/Echo-pro)
- Kimi API Docs: [platform.moonshot.cn](https://platform.moonshot.cn)
- Railway Docs: [docs.railway.app](https://docs.railway.app)

---

**صنع بحب ❤️ | Echo Pro v3.0**
