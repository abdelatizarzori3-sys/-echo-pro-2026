# 🚀 Echo Pro 2026 — دليل الاختبار والنشر الكامل

> **التاريخ:** 2026-08-19  
> **الإصدار:** 3.0.0  
> **الحالة:** جاهز للاختبار والنشر

---

## 📋 محتويات الدليل

1. ✅ فحص جميع المكونات
2. 🧪 الاختبار المحلي
3. 🐳 الاختبار مع Docker
4. 🌐 النشر على الإنتاج
5. 🔍 استكشاف الأخطاء

---

## ✅ المرحلة 1: فحص المكونات

### 1.1 فحص البنية الأساسية

```bash
# تحقق من المشروع الرئيسي
cd ~/echo-pro-2026

# تحقق من المجلدات الأساسية
ls -la

# المتوقع:
# backend/          — API Node.js
# lib/              — تطبيق Flutter
# .github/          — GitHub Actions
# docker-compose.yml
# pubspec.yaml
# package.json (في الجذر أم في backend/)
```

### 1.2 فحص Backend

```bash
cd backend

# تحقق من الملفات الأساسية
ls -la
# المتوقع:
# ✅ package.json
# ✅ server.js
# ✅ Dockerfile
# ✅ .env.example
# ✅ prisma/
# ✅ src/

# تحقق من الإصدارات
node --version        # >= 20.0.0
npm --version         # >= 10.0.0

# تثبيت الحزم
npm install

# تحقق من البنية
cd src
ls -la
# المتوقع:
# ✅ app.js
# ✅ server.js
# ✅ config/
# ✅ routes/
# ✅ controllers/
# ✅ services/
# ✅ middleware/
# ✅ websocket/
```

### 1.3 فحص Flutter

```bash
cd ../.
cd lib  # أو مجلد Flutter الرئيسي

# تحقق من الإصدارات
flutter --version      # >= 3.4.0
dart --version         # >= 3.4.0

# تحقق من البنية
ls -la
# المتوقع:
# ✅ main.dart
# ✅ core/
# ✅ features/
# ✅ widgets/
# ✅ services/

# تحقق من pubspec.yaml
cd ..
cat pubspec.yaml
```

---

## 🧪 المرحلة 2: الاختبار المحلي بدون Docker

### 2.1 إعداد قاعدة البيانات المحلية

```bash
# إذا كان لديك PostgreSQL مثبت محلياً
createdb echo_db
createuser echo_user -P  # ضع كلمة المرور: echo_password

# أو استخدم Docker فقط لـ PostgreSQL
docker run -d \
  --name echo-postgres \
  -e POSTGRES_USER=echo_user \
  -e POSTGRES_PASSWORD=echo_password \
  -e POSTGRES_DB=echo_db \
  -p 5432:5432 \
  postgres:16-alpine
```

### 2.2 اختبار Backend

```bash
cd backend

# أنشئ ملف .env
cp .env.example .env

# عدّل .env
# NODE_ENV=development
# PORT=3000
# DATABASE_URL=postgresql://echo_user:echo_password@localhost:5432/echo_db
# KIMI_API_KEY=sk-your-test-key  (أو اتركه فارغاً للاختبار)
# JWT_SECRET=your-super-secret-key-32-chars-long

# تثبيت الحزم إن لم تكن مثبتة
npm install

# إعداد Prisma
npx prisma generate
npx prisma migrate dev --name init

# اختياري: إضافة بيانات تجريبية
npx prisma db seed

# شغّل الخادم
npm run dev
# المتوقع: 
# ✅ 🚀 Echo Backend running on port 3000 in development mode
# ✅ ✅ PostgreSQL connected successfully
```

### 2.3 اختبار Flutter

**في نافذة terminal جديدة:**

```bash
cd ../
# أو cd إلى مجلد Flutter الرئيسي

# تحقق من الاتصال
flutter doctor

# احصل على الحزم
flutter pub get

# اختبر البناء للويب
flutter build web --debug
# أو
flutter run -d web

# المتوقع:
# ✅ Flutter web app يفتح على http://localhost:5000
# ✅ صفحة تسجيل الدخول تظهر
```

### 2.4 اختبار الاتصال بين الـ Frontend و Backend

```bash
# تحقق من أن Backend يعمل على http://localhost:3000
curl http://localhost:3000/api/health
# المتوقع:
# {"status":"ok","timestamp":"2026-08-19T..."}

# إذا حصلت على CORS error:
# راجع backend/src/config/cors.js
```

---

## 🐳 المرحلة 3: الاختبار مع Docker

### 3.1 بناء صور Docker

```bash
cd ~/echo-pro-2026

# اختبت بناء صورة Backend
docker build -f backend/Dockerfile -t echo-backend:latest ./backend

# تحقق من البناء
docker images | grep echo-backend
```

### 3.2 تشغيل جميع الخدمات مع Docker Compose

```bash
# أنشئ ملف .env في الجذر
cat > .env << EOF
KIMI_API_KEY=sk-your-test-key-here
JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
EOF

# شغّل docker-compose
docker-compose up --build

# المتوقع:
# ✅ postgres logs: PostgreSQL started
# ✅ redis logs: Redis server started
# ✅ backend logs: Echo Backend running on port 3000
# ✅ nginx logs: started

# انتظر 10 ثوانٍ ثم اختبر
curl http://localhost/api/health

# للإيقاف
docker-compose down

# لمسح البيانات والبدء من جديد
docker-compose down -v
```

### 3.3 عرض السجلات

```bash
# سجلات Backend
docker-compose logs backend

# سجلات قاعدة البيانات
docker-compose logs postgres

# سجلات جميع الخدمات
docker-compose logs -f
```

---

## 🧪 المرحلة 4: الاختبارات الآلية

### 4.1 اختبار Backend

```bash
cd backend

# تشغيل الاختبارات
npm test

# اختبار مع المراقبة
npm run test:watch

# اختبار مع التغطية
npm test -- --coverage

# المتوقع:
# ✅ Auth tests: X passed
# ✅ Chat tests: X passed
# ✅ Middleware tests: X passed
```

### 4.2 اختبار Flutter

```bash
cd ../

# اختبر جميع الملفات
flutter test

# اختبار ملف معين
flutter test test/features/auth_test.dart

# المتوقع:
# ✅ All tests passed
```

### 4.3 فحص الأخطاء

```bash
# Backend
cd backend
npm run lint

# Flutter
cd ../
flutter analyze

# المتوقع:
# ✅ No errors found
```

---

## 🌐 المرحلة 5: النشر على الإنتاج

### 5.1 نشر Backend على Railway

#### الخطوة 1: إعداد Railway

```bash
# تثبيت Railway CLI
npm install -g @railway/cli

# تسجيل الدخول
railway login

# ربط المشروع
railway link

# أضف PostgreSQL
railway add --database postgres
```

#### الخطوة 2: ضبط متغيرات البيئة

```bash
# اضبط المتغيرات في Railway Dashboard
railway variables set NODE_ENV=production
railway variables set PORT=3000
railway variables set KIMI_API_KEY=sk-your-real-key-here
railway variables set JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
railway variables set CORS_ORIGIN=https://your-domain.com

# تحقق من المتغيرات
railway variables
```

#### الخطوة 3: النشر

```bash
# انشر الكود
railway up

# المتوقع:
# ✅ Deployment successful
# ✅ API running at: https://echo-api.up.railway.app

# اختبر الـ API
curl https://echo-api.up.railway.app/api/health
```

### 5.2 نشر Flutter على Vercel

#### الخطوة 1: بناء Flutter Web

```bash
flutter build web --release

# سيُنشئ مجلد build/web/
```

#### الخطوة 2: نشر على Vercel

**الطريقة 1: عبر CLI**

```bash
npm install -g vercel

vercel --prod

# المتوقع:
# ✅ Production deployment ready at: https://your-app.vercel.app
```

**الطريقة 2: عبر GitHub**

```bash
# ارفع الكود إلى GitHub
git add .
git commit -m "feat: production build"
git push origin main

# اذهب إلى vercel.com
# اربط مستودع GitHub
# اختر branch (main)
# Vercel ستنشر تلقائياً
```

#### الخطوة 3: تحديث API_BASE_URL

عدّل `lib/.env` أو استخدم متغيرات البيئة في Vercel:

```
API_BASE_URL=https://echo-api.up.railway.app/api
WEBSOCKET_URL=wss://echo-api.up.railway.app
```

---

## 🔍 المرحلة 6: استكشاف الأخطاء

### خطأ 1: Database Connection Failed

```
❌ Error: ECONNREFUSED 127.0.0.1:5432
```

**الحل:**

```bash
# تحقق من DATABASE_URL في .env
echo $DATABASE_URL

# تحقق من PostgreSQL
docker ps | grep postgres

# أعد تشغيل PostgreSQL
docker restart echo-postgres

# أو تشغيل يدوي
createdb echo_db 2>/dev/null || true
```

### خطأ 2: Prisma Migration Failed

```
❌ Error: prisma migrate deploy failed
```

**الحل:**

```bash
# في المجلد backend
npm install
npx prisma generate
npx prisma migrate dev --name fix
```

### خطأ 3: KIMI_API_KEY Missing

```
❌ 🔑 Kimi AI Integration: MISSING
```

**الحل:**

```bash
# احصل على مفتاح مجاني من:
# https://platform.moonshot.cn

# أضفه في Railway أو .env
export KIMI_API_KEY=sk-your-key-here
```

### خطأ 4: CORS Error في Flutter

```
❌ Access to XMLHttpRequest blocked by CORS policy
```

**الحل:**

```javascript
// backend/src/config/cors.js
const corsOptions = {
  origin: [
    'http://localhost:5000',      // dev
    'https://your-domain.com',    // production
    'https://your-app.vercel.app' // Vercel
  ],
  methods: ['GET', 'POST'],
  credentials: true
};
```

### خطأ 5: Flutter Build Error

```
❌ Error: lib/main.dart not found
```

**الحل:**

```bash
# تحقق من البنية
ls -la lib/main.dart

# إذا لم يكن موجود، أنشئه
flutter create .
```

---

## ✅ قائمة التحقق النهائية

قبل النشر على الإنتاج، تأكد من:

- [ ] **Backend يعمل محلياً** (`npm run dev`)
- [ ] **Flutter يعمل محلياً** (`flutter run`)
- [ ] **Docker Compose يعمل** (`docker-compose up`)
- [ ] **جميع الاختبارات تمر** (`npm test` و `flutter test`)
- [ ] **KIMI_API_KEY موجود** (ليس `YOUR_KEY_HERE`)
- [ ] **JWT_SECRET آمن** (32+ حرف عشوائي)
- [ ] **قاعدة البيانات مهاجرة** (`npx prisma migrate deploy`)
- [ ] **GitHub متحدث** (`git status` يظهر clean)
- [ ] **Railway مربوط** (`railway status` يعمل)
- [ ] **Vercel مربوط** (Dashboard يظهر المشروع)

---

## 📊 الأداء والمراقبة

### تحقق من الأداء

```bash
# محمل الخادم
curl -i http://localhost:3000/api/health

# معلومات النظام
docker stats

# السجلات
docker-compose logs -f backend
```

### ضبط الأداء

```bash
# في backend/src/config/env.js
NODE_ENV = 'production'
LOG_LEVEL = 'error'  // قلل السجلات
```

---

## 🎯 الخطوات التالية

بعد النشر بنجاح:

1. ✅ راقب السجلات: `railway logs`
2. ✅ اختبر API: `curl https://your-api.com/api/health`
3. ✅ اختبر الـ Frontend: افتح التطبيق في المتصفح
4. ✅ اختبر المراقبة: تحقق من Sentry dashboard
5. ✅ اختبر CORS: اختبر الطلبات من دول مختلفة

---

## 📞 دعم وموارد

- **Kimi API Docs**: https://platform.moonshot.cn/docs
- **Railway Docs**: https://docs.railway.app
- **Flutter Docs**: https://docs.flutter.dev
- **Vercel Docs**: https://vercel.com/docs

---

**تم التحديث:** 2026-08-19  
**الحالة:** ✅ جاهز للاختبار والنشر  
**أنت الآن جاهز لنشر Echo Pro!** 🚀