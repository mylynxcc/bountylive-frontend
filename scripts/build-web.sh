#!/usr/bin/env bash
#
# ╔══════════════════════════════════════════════════════════════╗
# ║     BountyLive — Flutter Web Build & Deploy Script          ║
# ║  Builds the Flutter web app and copies it into Laravel's    ║
# ║  public/ directory so the preview server serves the real UI ║
# ╚══════════════════════════════════════════════════════════════╝
#
# Usage:
#   cd /path/to/bountylive/frontend
#   chmod +x scripts/build-web.sh
#   ./scripts/build-web.sh
#
# Prerequisites:
#   - Flutter SDK 3.7+ installed and on PATH
#   - `flutter pub get` already run
#   - Laravel backend at ../backend/
#
# What it does:
#   1. Runs `flutter build web --release`
#   2. Copies all output into backend/public/flutter/
#   3. Copies key files (flutter.js, main.dart.js, assets/) to backend/public/
#   4. Shows a summary of what was deployed
#

set -euo pipefail

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { printf "${BLUE}[INFO]${NC}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
error()   { printf "${RED}[ERR]${NC}   %s\n" "$*"; }
header()  { printf "\n${CYAN}═══════════════════════════════════════════${NC}\n${BOLD}%s${NC}\n${CYAN}───────────────────────────────────────────${NC}\n" "$*"; }

# ── Resolve paths ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKEND_PUBLIC="$(cd "$FRONTEND_DIR/../backend/public" && pwd)"
BUILD_DIR="$FRONTEND_DIR/build/web"

# ── Pre-flight checks ──
header "Pre-flight Checks"

if ! command -v flutter &>/dev/null; then
  error "Flutter SDK not found. Install it from https://flutter.dev"
  exit 1
fi

if [[ ! -d "$FRONTEND_DIR" ]]; then
  error "Frontend directory not found at $FRONTEND_DIR"
  exit 1
fi

if [[ ! -d "$BACKEND_PUBLIC" ]]; then
  error "Laravel public/ directory not found at $BACKEND_PUBLIC"
  info "Expected: $FRONTEND_DIR/../backend/public/"
  exit 1
fi

if [[ ! -f "$FRONTEND_DIR/pubspec.yaml" ]]; then
  error "No pubspec.yaml found in $FRONTEND_DIR"
  info "Run this script from the frontend/ directory or its scripts/ subdirectory."
  exit 1
fi

success "Flutter: $(flutter --version 2>&1 | head -1)"
success "Frontend: $FRONTEND_DIR"
success "Target:    $BACKEND_PUBLIC"

# ── Step 1: Clean previous build ──
header "Step 1: Cleaning previous build"
rm -rf "$BUILD_DIR"
info "Cleaned $BUILD_DIR"
success "Done"

# ── Step 2: Build Flutter web ──
header "Step 2: Building Flutter Web (--release)"
echo ""
flutter build web --release --no-tree-shake-icons
success "Flutter web build complete"

# ── Step 3: Verify build output ──
header "Step 3: Verifying build output"

if [[ ! -f "$BUILD_DIR/main.dart.js" ]]; then
  error "Build failed — main.dart.js not found in $BUILD_DIR"
  ls -la "$BUILD_DIR" 2>/dev/null || true
  exit 1
fi

# Get file sizes for summary
MAIN_SIZE=$(du -h "$BUILD_DIR/main.dart.js" | cut -f1)
TOTAL_SIZE=$(du -sh "$BUILD_DIR" | cut -f1)
ASSET_COUNT=$(find "$BUILD_DIR/assets" -type f 2>/dev/null | wc -l | xargs)

success "main.dart.js: ${MAIN_SIZE}"
success "Total build: ${TOTAL_SIZE} (${ASSET_COUNT} assets)"
success "Output: $BUILD_DIR"

# ── Step 4: Deploy to Laravel public/ ──
header "Step 4: Deploying to Laravel public/"

# Remove previous Flutter deployment (flutter/ subdir)
rm -rf "$BACKEND_PUBLIC/flutter"
info "Cleaned previous flutter/ from $BACKEND_PUBLIC"

# Remove old root-level Flutter files if they exist
rm -f "$BACKEND_PUBLIC/main.dart.js" \
      "$BACKEND_PUBLIC/flutter.js" \
      "$BACKEND_PUBLIC/flutter_service_worker.js" \
      "$BACKEND_PUBLIC/manifest.json" \
      "$BACKEND_PUBLIC/favicon.ico" \
      "$BACKEND_PUBLIC/icons/Icon-192.png" \
      "$BACKEND_PUBLIC/icons/Icon-512.png"
info "Cleaned old root-level Flutter files"

# ── Strategy: copy everything into public/flutter/ ──
# Laravel's asset() helper can reference public/flutter/...
# and the SPA shell loads the bootstrap from there.
cp -r "$BUILD_DIR" "$BACKEND_PUBLIC/flutter"
success "Copied build output to $BACKEND_PUBLIC/flutter/"

# ── Symlink key files at root for backward compatibility ──
ln -sf flutter/flutter.js "$BACKEND_PUBLIC/flutter.js"
ln -sf flutter/flutter_service_worker.js "$BACKEND_PUBLIC/flutter_service_worker.js"
ln -sf flutter/main.dart.js "$BACKEND_PUBLIC/main.dart.js"
ln -sf flutter/manifest.json "$BACKEND_PUBLIC/manifest.json"
ln -sf flutter/favicon.ico "$BACKEND_PUBLIC/favicon.ico"
ln -sf flutter/icons "$BACKEND_PUBLIC/icons"
success "Symlinked key files at public root"

# ── Step 5: Summary ──
header "Deployment Summary"
echo ""
printf "  ${BOLD}%-30s${NC} %s\n" "Flutter version" "$(flutter --version 2>&1 | head -1)"
printf "  ${BOLD}%-30s${NC} %s\n" "Build mode" "Release"
printf "  ${BOLD}%-30s${NC} %s\n" "main.dart.js" "$MAIN_SIZE"
printf "  ${BOLD}%-30s${NC} %s\n" "Total assets" "$ASSET_COUNT files"
printf "  ${BOLD}%-30s${NC} %s\n" "Deployed to" "$BACKEND_PUBLIC/flutter/"
printf "  ${BOLD}%-30s${NC} %s\n" "Root symlinks" "flutter.js, main.dart.js, manifest.json, favicon.ico, icons/"
printf "  ${BOLD}%-30s${NC} %s\n" "Served at" "http://localhost:8000"
echo ""

# ── Step 6: Verify ──
header "Step 6: Verification"

if [[ -f "$BACKEND_PUBLIC/flutter/main.dart.js" ]]; then
  success "✅ Flutter web deployed — main.dart.js present at flutter/main.dart.js"
else
  error "Deployment failed — flutter/main.dart.js not found"
  exit 1
fi

if [[ -f "$BACKEND_PUBLIC/flutter/flutter_service_worker.js" ]]; then
  success "✅ Service worker deployed — PWA ready"
else
  warn "Service worker not found (Flutter may need to rebuild)"
fi

if [[ -d "$BACKEND_PUBLIC/flutter/assets" ]]; then
  ASSET_COUNT_POST=$(find "$BACKEND_PUBLIC/flutter/assets" -type f | wc -l | xargs)
  success "✅ Assets deployed — $ASSET_COUNT_POST files in flutter/assets/"
fi

echo ""
header "Next Steps"
cat << NEXTSTEPS

  ${GREEN}✓${NC} Flutter web is deployed.

  ${BLUE}➜${NC} Restart the Laravel preview server to see the app:
      cd backend && php artisan serve --port=8000

  ${BLUE}➜${NC} The SPA shell (resources/views/app.blade.php) will detect
      flutter_service_worker.js and hide the fallback screen,
      loading the Flutter app instead.

  ${BLUE}➜${NC} If the API base URL needs changing for web, pass it at build time:
      flutter build web --release --dart-define=API_BASE_URL=https://yourdomain.com/api/v1

NEXTSTEPS

success "BountyLive Flutter web build & deploy complete!"
