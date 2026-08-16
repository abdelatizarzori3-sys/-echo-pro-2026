#!/bin/bash
# ============================================================
#  Echo Pro 2026 — Full Deployment Script
#  يعمل على Termux | ينشر Frontend + Backend
# ============================================================

set -e

echo "========================================"
echo "  🚀 Echo Pro 2026 - Deploy Script"
echo "========================================"
echo ""

# ─── الألوان ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ─── التحقق من Git ───
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ git غير مثبت. ثبته أولاً:${NC} pkg install git"
    exit 1
fi

# ─── التحقق من المجلد ───
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ يجب تشغيل هذا السكربت من جذر مشروع Echo Pro (حيث يوجد pubspec.yaml)${NC}"
    exit 1
fi

PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")
echo -e "${BLUE}📁 المشروع:${NC} $PROJECT_NAME"
echo ""

# ─── إنشاء GitHub Actions Workflow ───
echo -e "${YELLOW}⏳ إنشاء GitHub Actions Workflow...${NC}"

mkdir -p .github/workflows

cat > .github/workflows/deploy.yml << 'WORKFLOW'
name: 🚀 Deploy Echo Pro 2026

on:
  push:
    branches: [main, master]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  # ─── بناء Flutter Web ───
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 📥 Checkout
        uses: actions/checkout@v4

      - name: 🎯 Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: 📦 Get Dependencies
        run: flutter pub get

      - name: 🔧 Build Flutter Web
        run: |
          flutter build web --release --base-href /${{ github.event.repository.name }}/

      - name: 📤 Upload Artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

  # ─── نشر على GitHub Pages ───
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: 🌐 Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
WORKFLOW

echo -e "${GREEN}✅ Workflow تم إنشاؤه${NC}"

# ─── إنشاء vercel.json (احتياطي لـ Vercel) ───
echo -e "${YELLOW}⏳ إنشاء vercel.json...${NC}"

cat > vercel.json << 'VERCEL'
{
  "version": 2,
  "builds": [
    {
      "src": "build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    { "handle": "filesystem" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
VERCEL

echo -e "${GREEN}✅ vercel.json تم إنشاؤه${NC}"

# ─── إنشاء .gitignore محسّن ───
echo -e "${YELLOW}⏳ تحديث .gitignore...${NC}"

cat >> .gitignore << 'GITIGNORE'

# === Flutter Build ===
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
pubspec.lock

# === IDE ===
.idea/
.vscode/
*.iml

# === OS ===
.DS_Store
Thumbs.db

# === Secrets ===
.env
*.pem
key.properties
serviceAccountKey.json
GITIGNORE

echo -e "${GREEN}✅ .gitignore تم تحديثه${NC}"

# ─── Git Add / Commit / Push ───
echo ""
echo -e "${YELLOW}⏳ رفع التغييرات على GitHub...${NC}"
echo ""

git add .
git commit -m "chore: add GitHub Actions + Vercel config for deployment [skip ci]" || true
git push origin main || git push origin master || {
    echo -e "${RED}❌ فشل الرفع. تأكد من إعداد remote:${NC}"
    echo "   git remote add origin https://github.com/USERNAME/REPO.git"
    exit 1
}

echo ""
echo -e "${GREEN}✅ تم الرفع بنجاح!${NC}"
echo ""

# ─── النتائج ───
echo "========================================"
echo -e "${GREEN}  🎉 تم الانتهاء! الخطوات التالية:${NC}"
echo "========================================"
echo ""
echo -e "${BLUE}1️⃣  Frontend (GitHub Pages):${NC}"
echo "   اذهب إلى: Settings → Pages → Source: GitHub Actions"
echo "   الموقع سيكون: https://YOURNAME.github.io/REPO-NAME"
echo ""
echo -e "${BLUE}2️⃣  Backend (Railway):${NC}"
echo "   اذهب إلى: https://railway.app"
echo "   New Project → Deploy from GitHub repo"
echo "   اختر نفس المستودع → Railway يقرأ railway.toml تلقائياً"
echo ""
echo -e "${BLUE}3️⃣  Frontend (Vercel - اختياري):${NC}"
echo "   اذهب إلى: https://vercel.com"
echo "   Add New Project → Import Git Repo"
echo "   Framework: Other | Output: build/web"
echo ""
echo -e "${YELLOW}⚠️  ملاحظات مهمة:${NC}"
echo "   • GitHub Actions ستبني Flutter Web تلقائياً (لا تحتاج Termux)"
echo "   • Backend ينفصل عن Frontend — كل واحد على استضافة مختلفة"
echo "   • غيّر API URL في Flutter ليشير إلى Railway backend"
echo ""
echo "========================================"
