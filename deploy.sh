#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# Echo Pro — Automated Deployment Script
# Usage: ./deploy.sh [local|railway|docker]
# ═══════════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# ─── Validate Environment ──────────────────────────────────────
validate_env() {
    print_status "Validating environment..."

    if ! command -v node &> /dev/null; then
        print_error "Node.js not found. Install from https://nodejs.org"
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        print_warning "Docker not found. Docker deployment will fail."
    fi

    print_success "Environment validated"
}

# ─── Local Development ─────────────────────────────────────────
deploy_local() {
    print_status "Starting local development environment..."

    # Check .env
    if [ ! -f backend/.env ]; then
        print_warning "backend/.env not found. Copying from .env.example..."
        cp backend/.env.example backend/.env
        print_warning "Please edit backend/.env with your credentials!"
    fi

    # Install dependencies
    print_status "Installing backend dependencies..."
    cd backend
    npm install

    # Generate Prisma client
    print_status "Generating Prisma client..."
    npx prisma generate

    # Run migrations
    print_status "Running database migrations..."
    npx prisma migrate dev

    # Seed database
    print_status "Seeding database..."
    npx prisma db seed

    # Start server
    print_success "Starting server..."
    cd ..
    npm run dev
}

# ─── Docker Deployment ─────────────────────────────────────────
deploy_docker() {
    print_status "Building Docker containers..."

    if [ ! -f .env ]; then
        print_warning ".env not found. Copying from .env.example..."
        cp .env.example .env
        print_warning "Please edit .env with your credentials!"
    fi

    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d

    print_status "Running database migrations..."
    docker-compose exec backend npx prisma migrate deploy

    print_success "Docker deployment complete!"
    print_status "API: http://localhost:3000"
    print_status "Docs: http://localhost:3000/api/docs"
}

# ─── Railway Deployment ────────────────────────────────────────
deploy_railway() {
    print_status "Deploying to Railway..."

    if ! command -v railway &> /dev/null; then
        print_error "Railway CLI not found. Install: npm install -g @railway/cli"
        exit 1
    fi

    railway login
    railway up

    print_success "Railway deployment complete!"
    print_status "Check dashboard: https://railway.app/dashboard"
}

# ─── Flutter Build ────────────────────────────────────────────
build_flutter() {
    print_status "Building Flutter app..."

    if ! command -v flutter &> /dev/null; then
        print_error "Flutter not found. Install from https://flutter.dev"
        exit 1
    fi

    flutter pub get
    flutter analyze
    flutter test

    print_status "Building APK..."
    flutter build apk --release

    print_status "Building App Bundle..."
    flutter build appbundle --release

    print_success "Flutter build complete!"
    print_status "APK: build/app/outputs/flutter-apk/app-release.apk"
    print_status "AAB: build/app/outputs/bundle/release/app-release.aab"
}

# ─── Main ──────────────────────────────────────────────────────
main() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║           🤖 Echo Pro — Deployment Script v3.0              ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    validate_env

    case "${1:-local}" in
        local)
            deploy_local
            ;;
        docker)
            deploy_docker
            ;;
        railway)
            deploy_railway
            ;;
        flutter)
            build_flutter
            ;;
        all)
            deploy_docker
            build_flutter
            ;;
        *)
            echo "Usage: $0 [local|docker|railway|flutter|all]"
            echo ""
            echo "Commands:"
            echo "  local    — Start local development server"
            echo "  docker   — Deploy with Docker Compose"
            echo "  railway  — Deploy to Railway"
            echo "  flutter  — Build Flutter app"
            echo "  all      — Docker + Flutter"
            exit 1
            ;;
    esac
}

main "$@"
