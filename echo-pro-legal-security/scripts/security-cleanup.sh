#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Echo Pro — Security Cleanup & Git History Purge
# Usage: chmod +x security-cleanup.sh && ./security-cleanup.sh
# WARNING: This will rewrite Git history. Backup first!
# ═══════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║     🔒 Echo Pro — Security Cleanup & History Purge            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ─── Step 0: Backup ────────────────────────────────────────────
echo -e "${YELLOW}⚠️  Creating backup...${NC}"
BACKUP_DIR="../echo-pro-backup-$(date +%Y%m%d-%H%M%S)"
cp -r . "$BACKUP_DIR"
echo -e "${GREEN}✅ Backup created: $BACKUP_DIR${NC}"

# ─── Step 1: Install BFG Repo-Cleaner ─────────────────────────
echo -e "${BLUE}ℹ️  Installing BFG Repo-Cleaner...${NC}"
if ! command -v bfg &> /dev/null; then
    wget -q https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar -O /tmp/bfg.jar
    echo 'alias bfg="java -jar /tmp/bfg.jar"' >> ~/.bashrc
    alias bfg="java -jar /tmp/bfg.jar"
    echo -e "${GREEN}✅ BFG installed${NC}"
else
    echo -e "${GREEN}✅ BFG already installed${NC}"
fi

# ─── Step 2: Remove sensitive files from history ────────────────
echo -e "${BLUE}ℹ️  Removing sensitive files from Git history...${NC}"

# Files to purge
SENSITIVE_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "backend/.env"
    "backend/.env.local"
    "android/key.properties"
    "android/app/key.jks"
    "ios/Runner/GoogleService-Info.plist"
    "*.pem"
    "*.key"
    "*.p12"
    "*.mobileprovision"
)

# Create removal list
for file in "${SENSITIVE_FILES[@]}"; do
    echo "$file" >> .git-rm-bfg.txt
done

# Run BFG
if command -v bfg &> /dev/null; then
    bfg --delete-files .env --no-blob-protection
    bfg --delete-files .env.local --no-blob-protection
    bfg --delete-files .env.production --no-blob-protection
    bfg --delete-files key.properties --no-blob-protection
    bfg --delete-files key.jks --no-blob-protection
    bfg --delete-files "*.pem" --no-blob-protection
    bfg --delete-files "*.key" --no-blob-protection
    bfg --delete-files "*.p12" --no-blob-protection
else
    java -jar /tmp/bfg.jar --delete-files .env --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files .env.local --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files .env.production --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files key.properties --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files key.jks --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files "*.pem" --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files "*.key" --no-blob-protection
    java -jar /tmp/bfg.jar --delete-files "*.p12" --no-blob-protection
fi

# Clean and garbage collect
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo -e "${GREEN}✅ Sensitive files removed from history${NC}"

# ─── Step 3: Replace secrets in history ─────────────────────────
echo -e "${BLUE}ℹ️  Replacing secrets in history...${NC}"

# Replace known leaked secrets
git filter-branch --force --index-filter     'git ls-files -z | xargs -0 sed -i "s/sk-wa91rIxnlKbLHkIlb4k9vRTejrm7CawZykrYcXbqs5ieFNyD/REDACTED_API_KEY/g"'     --prune-empty --tag-name-filter cat -- --all 2>/dev/null || true

git filter-branch --force --index-filter     'git ls-files -z | xargs -0 sed -i "s/your-super-secret-jwt-key-min-32-chars-long/REDACTED_JWT_SECRET/g"'     --prune-empty --tag-name-filter cat -- --all 2>/dev/null || true

echo -e "${GREEN}✅ Secrets replaced in history${NC}"

# ─── Step 4: Add .gitignore rules ─────────────────────────────
echo -e "${BLUE}ℹ️  Ensuring .gitignore is comprehensive...${NC}"

cat >> .gitignore << 'EOF'

# ─── SECURITY: Never commit these ──────────────────────────────
.env
.env.local
.env.production
.env.*.local
backend/.env
backend/.env.*
android/key.properties
android/app/*.jks
android/app/*.keystore
ios/Runner/GoogleService-Info.plist
ios/Runner/*.p12
*.pem
*.key
*.p12
*.mobileprovision
*.cer
*.crt
credentials.json
service-account.json
secrets/
EOF

echo -e "${GREEN}✅ .gitignore updated${NC}"

# ─── Step 5: Verify no secrets remain ─────────────────────────
echo -e "${BLUE}ℹ️  Scanning for remaining secrets...${NC}"

# Check for common patterns
PATTERNS=(
    "sk-[a-zA-Z0-9]{20,}"
    "JWT_SECRET=.*[^A-Z]"
    "password=.*[^*]"
    "api_key=.*[^*]"
    "DATABASE_URL=.*://.*:.*@"
)

FOUND=0
for pattern in "${PATTERNS[@]}"; do
    if git grep -q -E "$pattern" -- './*' ':!.gitignore' 2>/dev/null; then
        echo -e "${RED}❌ Found potential secret: $pattern${NC}"
        git grep -n -E "$pattern" -- './*' ':!.gitignore' 2>/dev/null || true
        FOUND=1
    fi
done

if [ $FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ No secrets found in current files${NC}"
fi

# ─── Step 6: Force push (optional) ────────────────────────────
echo -e "${YELLOW}"
echo "═══════════════════════════════════════════════════════════════"
echo "  ⚠️  IMPORTANT: Git history has been rewritten!"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"
echo "Next steps:"
echo "  1. Review changes: git log --oneline"
echo "  2. Test everything works locally"
echo "  3. Force push to GitHub:"
echo "     git push origin --force --all"
echo "     git push origin --force --tags"
echo ""
echo -e "${RED}WARNING: This will rewrite history for all collaborators!${NC}"
echo -e "${YELLOW}Make sure all team members know before force pushing.${NC}"

# ─── Step 7: Generate new secrets ─────────────────────────────
echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════"
echo "  🔑 Generate new secrets for production:"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo "JWT_SECRET (copy this):"
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))" 2>/dev/null || openssl rand -hex 64

echo ""
echo "KIMI_API_KEY: Get from https://platform.moonshot.cn"
echo ""
echo "DATABASE_URL: Set in Railway/Render dashboard only"

# Cleanup
rm -f .git-rm-bfg.txt

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           ✅ Security cleanup complete!                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
