#!/bin/bash
echo "=========================================="
echo "  🚀 Echo Pro 2026 - GitHub Push Script"
echo "=========================================="
echo ""

# اسم المستخدم (افتراضي: abdelatizarzori3-sys)
read -p "👤 أدخل اسم مستخدم GitHub [abdelatizarzori3-sys]: " USERNAME
USERNAME=${USERNAME:-abdelatizarzori3-sys}

# طلب التوكن بشكل مخفي (ما يظهر على الشاشة)
echo "🔑 الصق التوكن (Token) ثم اضغط Enter:"
echo "   (لن يظهر شيء على الشاشة - هذا طبيعي للأمان)"
read -s TOKEN
echo ""

# التحقق من المدخلات
if [ -z "$TOKEN" ]; then
    echo "❌ خطأ: لم تدخل التوكن!"
    exit 1
fi

REPO_URL="https://${TOKEN}@github.com/${USERNAME}/-echo-pro-2026-.git"

echo ""
echo "⏳ جاري الإعداد..."

# إزالة الـ remote القديم إن وجد
git remote remove origin 2>/dev/null

# إضافة الـ remote بالتوكن
git remote add origin "$REPO_URL"

echo "📤 جاري رفع المشروع إلى GitHub..."
echo ""

# رفع المشروع
git push -u origin main --force

# تنظيف التوكن من الرابط بعد الرفع (للأمان)
git remote set-url origin https://github.com/${USERNAME}/-echo-pro-2026-.git

echo ""
echo "=========================================="
echo "  ✅ تم الانتهاء!"
echo "=========================================="
