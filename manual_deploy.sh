#!/bin/bash
# ============================================================
#  Echo Pro 2026 — Manual Build & Deploy (Termux)
#  بناء يدوي + رفع مباشر (أضمن من GitHub Actions)
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "========================================"
echo "  🔧 Echo Pro 2026 - Manual Deploy"
echo "========================================"
echo ""

# ─── التحقق من المجلد ───
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ يجب تشغيل هذا السكربت من جذر المشروع${NC}"
    exit 1
fi

# ─── تثبيت Flutter SDK (إذا لم يكن مثبتاً) ───
if ! command -v flutter &> /dev/null; then
    echo -e "${YELLOW}⏳ تثبيت Flutter SDK...${NC}"

    # تحديث Termux
    pkg update -y
    pkg install -y git curl unzip xz-utils

    # تحميل Flutter
    cd $HOME
    git clone https://github.com/flutter/flutter.git -b stable --depth 1

    # إضافة Flutter للـ PATH
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    export PATH="$PATH:$HOME/flutter/bin"

    # تفعيل Web
    flutter config --enable-web

    echo -e "${GREEN}✅ Flutter مثبت${NC}"
else
    echo -e "${GREEN}✅ Flutter موجود${NC}"
fi

# ─── فحص Flutter ───
echo ""
echo -e "${BLUE}🔍 فحص Flutter...${NC}"
flutter doctor -v || true
echo ""

# ─── تنظيف وتحديث ───
echo -e "${YELLOW}⏳ تنظيف المشروع...${NC}"
flutter clean
flutter pub get
echo -e "${GREEN}✅ Dependencies جاهزة${NC}"

# ─── فحص الأخطاء ───
echo ""
echo -e "${YELLOW}⏳ فحص الأخطاء...${NC}"
flutter analyze || {
    echo -e "${RED}⚠️  هناك أخطاء في الكود. هل تريد الاستمرار؟ (y/n)${NC}"
    read -r response
    if [ "$response" != "y" ]; then
        exit 1
    fi
}

# ─── بناء Flutter Web ───
echo ""
echo -e "${YELLOW}⏳ بناء Flutter Web... قد يستغرق 5-10 دقائق${NC}"
flutter build web --release --base-href /echo-pro-legal-security/

if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ فشل البناء! build/web غير موجود${NC}"
    exit 1
fi

echo -e "${GREEN}✅ البناء نجح!${NC}"
echo ""

# ─── إنشاء فرع gh-pages يدوياً ───
echo -e "${YELLOW}⏳ إنشاء فرع gh-pages...${NC}"

# حفظ build/web
mkdir -p /tmp/echo_build
cp -r build/web/* /tmp/echo_build/

# إنشاء فرع جديد
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git checkout --orphan gh-pages-temp || true

# إزالة كل الملفات القديمة
rm -rf *

# نسخ ملفات البناء
cp -r /tmp/echo_build/* .

# إنشاء .nojekyll
touch .nojekyll

# Commit
git add .
git commit -m "Deploy Flutter Web build" || true

# Force push
git push origin gh-pages-temp:gh-pages --force || {
    echo -e "${RED}❌ فشل الرفع. تأكد من إعداد remote${NC}"
    git checkout "$BRANCH"
    exit 1
}

# العودة للفرع الأصلي
git checkout "$BRANCH"

# تنظيف
rm -rf /tmp/echo_build

echo ""
echo "========================================"
echo -e "${GREEN}  🎉 تم الانتهاء!${NC}"
echo "========================================"
echo ""
echo -e "${BLUE}🌐 Frontend:${NC}"
echo "   اذهب إلى GitHub → Settings → Pages"
echo "   Source: Deploy from a branch"
echo "   Branch: gh-pages / (root)"
echo ""
echo -e "${BLUE}🔗 الرابط سيكون:${NC}"
echo "   https://YOURNAME.github.io/echo-pro-legal-security"
echo ""
echo -e "${YELLOW}⚠️  ملاحظة:${NC}"
echo "   إذا لم يكن لديك Git remote مضبوط:"
echo "   git remote add origin https://github.com/USER/REPO.git"
echo "========================================"
