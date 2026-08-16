# 🔒 Echo Pro — Legal & Security Package

## 📦 ما يحتويه هذا الملف

حزمة شاملة تحتوي على:
1. **سكربت تنظيف أمان** — يزيل secrets من Git history
2. **وثائق ملكية قانونية** — لحماية حقوقك كمطور
3. **اتفاقيات بيع** — جاهزة للتوقيع مع المشترين

---

## 📁 هيكل الملفات

```
echo-pro-legal-security/
│
├── 📁 scripts/
│   └── 📄 security-cleanup.sh       ← سكربت تنظيف Git history
│
├── 📁 legal/
│   ├── 📄 LICENSE                    ← MIT + Commercial Clause
│   ├── 📄 COMMERCIAL_LICENSE.md      ← ترخيص تجاري (3 مستويات)
│   ├── 📄 PURCHASE_AGREEMENT.md      ← اتفاقية شراء جاهزة
│   ├── 📄 PRIVACY_POLICY.md          ← سياسة الخصوصية
│   ├── 📄 TERMS_OF_SERVICE.md        ← شروط الخدمة
│   └── 📄 COPYRIGHT_NOTICE.md        ← إشعار حقوق النشر
│
└── 📁 docs/
    ├── 📄 AUTHORS.md                 ← قائمة المؤلفين
    ├── 📄 CONTRIBUTING.md            ← دليل المساهمة
    ├── 📄 SECURITY.md                ← سياسة الأمان
    ├── 📄 CHANGELOG.md               ← سجل التغييرات
    └── 📄 CODE_OF_CONDUCT.md         ← قواعد السلوك
```

---

## 🚀 كيف تستخدم

### الخطوة 1: تنظيف Git History

```bash
cd ~/Echo-pro

# انسخ السكربت
cp echo-pro-legal-security/scripts/security-cleanup.sh .

# شغله
chmod +x security-cleanup.sh
./security-cleanup.sh

# اتبع التعليمات على الشاشة
```

**ما يفعله السكربت:**
- ✅ ينشئ backup قبل أي تعديل
- ✅ يثبت BFG Repo-Cleaner
- ✅ يزيل `.env`, `key.properties`, `*.pem` من التاريخ
- ✅ يستبدل secrets المكشوفة بـ `REDACTED`
- ✅ ينظف reflog ويعيد ضغط المستودع
- ✅ يفحص بقايا secrets
- ✅ يولد secrets جديدة

### الخطوة 2: إضافة الوثائق القانونية

```bash
# انسخ الوثائق للمشروع
cp echo-pro-legal-security/legal/* ~/Echo-pro/
cp echo-pro-legal-security/docs/* ~/Echo-pro/

# عدّل البيانات الشخصية
# - LICENSE: ضع اسمك وإيميلك
# - COMMERCIAL_LICENSE: اضبط الأسعار
# - PURCHASE_AGREEMENT: اضبط بياناتك
```

### الخطوة 3: ارفع على GitHub

```bash
git add .
git commit -m "chore: add legal docs and security cleanup"
git push origin main
```

---

## 💰 نموذج التسعير

| النسخة | السعر | الحقوق |
|--------|-------|--------|
| **Standard** | $79 | مشروع واحد تجاري |
| **Extended** | $199 | مشاريع غير محدودة + SaaS |
| **Enterprise** | $499 | كل شيء + دعم 6 أشهر |

---

## ⚠️ تحذيرات مهمة

1. **غيّر الإيميل** في كل الملفات من `abdelatizarzori3@gmail.com` إلى إيميلك الحقيقي
2. **غيّر الاسم** من "Abdelatiz Zarzori" إلى اسمك
3. **راجع المحامي** قبل استخدام هذه الوثائق في بيع حقيقي
4. **السكربت يعيد كتابة التاريخ** — تأكد من backup

---

## 📞 دعم

- GitHub: [@abdelatizarzori3-sys](https://github.com/abdelatizarzori3-sys)
- Email:abdelatizarzori3@gmail.com 

---

**© 2026 Abdelatiz Zarzori. All rights reserved.**
