#!/bin/bash
# ============================================================
#  🚀 Echo Pro 2026 — ONE SCRIPT TO DEPLOY
#  يعمل من Termux | بناء + نشر في خطوة واحدة
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║     🚀 Echo Pro 2026 — One-Click Deploy      ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# ─── التحقق من المجلد ───
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ خطأ: pubspec.yaml غير موجود!${NC}"
    echo -e "${YELLOW}💡 يجب تشغيل هذا السكربت داخل مجلد المشروع:${NC}"
    echo "   cd /storage/emulated/0/hh/echo-pro-legal-security"
    exit 1
fi

PROJECT_DIR=$(pwd)
REPO_NAME=$(basename "$PROJECT_DIR")
echo -e "${BLUE}📁 المشروع:${NC} $REPO_NAME"
echo ""

# ─── التحقق من Git ───
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⏳ تثبيت git...${NC}"
    pkg update -y && pkg install -y git
fi

# ─── التحقق من Flutter ───
if ! command -v flutter &> /dev/null; then
    if [ -d "$HOME/flutter/bin" ]; then
        export PATH="$PATH:$HOME/flutter/bin"
    else
        echo -e "${YELLOW}⏳ تثبيت Flutter SDK (~500MB)...${NC}"
        pkg update -y
        pkg install -y git curl unzip xz-utils clang cmake ninja pkg-config libgtk-3-dev
        cd $HOME
        git clone https://github.com/flutter/flutter.git -b stable --depth 1
        export PATH="$PATH:$HOME/flutter/bin"
        flutter config --enable-web
        echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    fi
fi

echo -e "${GREEN}✅ Flutter:$(flutter --version | head -1)${NC}"
echo ""

# ─── تنظيف وتحديث ───
echo -e "${YELLOW}⏳ جاري تحميل الـ packages...${NC}"
flutter clean > /dev/null 2>&1
flutter pub get
echo -e "${GREEN}✅ Packages جاهزة${NC}"
echo ""

# ─── فحص سريع للأخطاء ───
echo -e "${YELLOW}⏳ فحص الأخطاء...${NC}"
flutter analyze --no-pub --no-congratulations 2>&1 | head -20 || true
echo ""

# ─── بناء Flutter Web ───
echo -e "${YELLOW}⏳ بناء Flutter Web... (قد يستغرق 5-15 دقيقة)${NC}"
echo -e "${CYAN}   لا تغلق Termux! انتظر...${NC}"
echo ""

flutter build web --release --base-href "/${REPO_NAME}/" 2>&1 | tee /tmp/flutter_build.log

if [ ! -f "build/web/index.html" ]; then
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ❌ فشل البناء! build/web/index.html مفقود  ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}📋 آخر 20 سطر من الأخطاء:${NC}"
    tail -20 /tmp/flutter_build.log
    echo ""
    echo -e "${YELLOW}💡 الحلول المقترحة:${NC}"
    echo "   1. flutter doctor -v    ← فحص المشاكل"
    echo "   2. flutter analyze      ← رؤية الأخطاء بالتفصيل"
    echo "   3. شارك الملفات معي لأبنيها لك"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ البناء نجح!${NC}"
echo ""

# ─── إنشاء فرع gh-pages ───
echo -e "${YELLOW}⏳ إنشاء فرع gh-pages...${NC}"

# حفظ الملفات
mkdir -p /tmp/echo_deploy
cp -r build/web/* /tmp/echo_deploy/
touch /tmp/echo_deploy/.nojekyll

# التحقق من الـ remote
if ! git remote get-url origin &> /dev/null; then
    echo -e "${RED}❌ لا يوجد Git remote!${NC}"
    echo -e "${YELLOW}💡 شغل هذا الأمر أولاً:${NC}"
    echo "   git remote add origin https://github.com/YOURNAME/${REPO_NAME}.git"
    exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# إنشاء فرع gh-pages نظيف
git checkout --orphan gh-pages-temp 2>/dev/null || git checkout -B gh-pages-temp
git rm -rf . 2>/dev/null || true

# نسخ ملفات البناء
cp -r /tmp/echo_deploy/* .

# commit
git add .
git commit -m "🚀 Deploy Flutter Web — $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || true

# push force
echo -e "${YELLOW}⏳ رفع على GitHub...${NC}"
git push origin gh-pages-temp:gh-pages --force

# العودة للفرع الأصلي
git checkout "$CURRENT_BRANCH" 2>/dev/null || git checkout main 2>/dev/null || git checkout master

# تنظيف
rm -rf /tmp/echo_deploy /tmp/flutter_build.log

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  🎉 تم النشر بنجاح!                          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}🔗 الخطوة الأخيرة (يدوية):${NC}"
echo ""
echo -e "   1️⃣  افتح:${CYAN} https://github.com/YOURNAME/${REPO_NAME}/settings/pages${NC}"
echo -e "   2️⃣  Source: ${YELLOW}Deploy from a branch${NC}"
echo -e "   3️⃣  Branch: ${YELLOW}gh-pages / (root)${NC}"
echo -e "   4️⃣  اضغط Save"
echo ""
echo -e "   ⏳ انتظر 1-2 دقيقة..."
echo ""
echo -e "${GREEN}🌐 موقعك سيكون على:${NC}"
echo -e "${CYAN}   https://YOURNAME.github.io/${REPO_NAME}${NC}"
echo ""
echo -e "${YELLOW}⚠️  ملاحظات:${NC}"
echo "   • غيّر YOURNAME لاسم المستخدم الخاص بك"
echo "   • Backend منفصل — انشره على Railway"
echo "   • إذا أردت Vercel: ارفع build/web مباشرة"
echo ""
