#!/bin/bash
#===============================================================================
# BountyLive Release Build Script
# Builds APK (Android), IPA (iOS), and Web bundles.
#
# Prerequisites:
#   - Flutter SDK installed (3.29+)
#   - Android: Android SDK, keystore file at android/key.jks
#   - iOS: macOS + Xcode 16+, Apple Developer account registered
#
# Usage:
#   ./scripts/release_build.sh [apk|ipa|web|all|ios-notest]
#
# Example:
#   ./scripts/release_build.sh apk          # Build release APK only
#   ./scripts/release_build.sh ipa          # Build release IPA only
#   ./scripts/release_build.sh all          # Build APK + IPA + web
#===============================================================================

set -euo pipefail

# ── Configuration ────────────────────────────────────────────────────────────
API_BASE_URL="${API_BASE_URL:-https://api.bountylive.com/api/v1}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SCRIPT_NAME=$(basename "$0")

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Helper Functions ─────────────────────────────────────────────────────────

check_flutter() {
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter SDK is not installed."
        log_error "Install it: brew install --cask flutter"
        exit 1
    fi
    log_info "Flutter version: $(flutter --version | head -1)"
}

check_android_sdk() {
    if [ -z "${ANDROID_HOME:-}" ] && [ -z "${ANDROID_SDK_ROOT:-}" ]; then
        log_warn "ANDROID_HOME is not set. Android builds may fail."
    fi
}

check_ios_env() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "iOS builds require macOS."
        exit 1
    fi
    if ! command -v xcodebuild &> /dev/null; then
        log_error "Xcode is not installed."
        exit 1
    fi
    log_info "Xcode version: $(xcodebuild -version | head -1)"
}

clean_project() {
    log_info "Cleaning project..."
    flutter clean
    rm -rf build/
    rm -rf ios/Pods ios/.symlinks
    log_ok "Clean complete"
}

get_dependencies() {
    log_info "Installing dependencies..."
    flutter pub get
    log_ok "Dependencies installed"
}

# ── Build Commands ───────────────────────────────────────────────────────────

build_apk() {
    log_info "Building release APK..."
    check_android_sdk

    # Verify keystore exists for release signing
    if [ ! -f "android/key.jks" ] && [ ! -f "android/key.properties" ]; then
        log_warn "No keystore found at android/key.jks"
        log_warn "Release builds will fail without a signed keystore."
        log_warn "Generate one: keytool -genkey -v -keystore android/key.jks -alias bountylive -keyalg RSA -keysize 2048 -validity 10000"
    fi

    flutter build apk --release \
        --split-per-abi \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=BUILD_DATE="$BUILD_DATE" \
        --target-platform android-arm,android-arm64,android-x64

    log_ok "APK builds complete!"
    ls -lh build/app/outputs/flutter-apk/*.apk

    # Build Android App Bundle
    log_info "Building Android App Bundle (AAB)..."
    flutter build appbundle --release \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=BUILD_DATE="$BUILD_DATE"

    log_ok "AAB build complete!"
    ls -lh build/app/outputs/bundle/release/*.aab
}

build_ipa() {
    log_info "Building release IPA..."
    check_ios_env

    # Clean pods for fresh build
    (cd ios && rm -rf Pods Podfile.lock && pod install --repo-update)

    flutter build ios --release \
        --no-codesign \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=BUILD_DATE="$BUILD_DATE"

    log_ok "iOS build complete (unsigned)"

    # Create IPA from app bundle
    log_info "Creating IPA..."
    mkdir -p build/ios/ipa/Payload
    cp -r build/ios/Release-iphoneos/Runner.app build/ios/ipa/Payload/
    (cd build/ios/ipa && zip -r ../BountyLive.ipa Payload/)
    rm -rf build/ios/ipa/Payload

    log_ok "IPA created at build/ios/BountyLive.ipa"
    ls -lh build/ios/BountyLive.ipa

    log_warn "The IPA is unsigned. Sign with Apple Developer certificate:"
    log_warn "  flutter build ios --release"
    log_warn "  (then Archive from Xcode)"
}

build_web() {
    log_info "Building release web bundle..."
    flutter build web --release \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=BUILD_DATE="$BUILD_DATE" \
        --base-href "/"

    log_ok "Web build complete!"
    ls -lh build/web/
    log_info "Deploy build/web/ to any static hosting (Vercel, Netlify, Cloudflare Pages, etc.)"
}

build_all() {
    build_apk
    build_ipa
    build_web
}

create_keystore() {
    if [ -f "android/key.jks" ]; then
        log_warn "Keystore already exists at android/key.jks"
        return
    fi
    local ks_pass="${KEYSTORE_PASSWORD:-$(openssl rand -base64 18)}"
    log_info "Generating Android keystore..."
    keytool -genkey -v \
        -keystore android/key.jks \
        -alias bountylive \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storepass "$ks_pass" \
        -keypass "$ks_pass" \
        -dname "CN=BountyLive, OU=Development, O=BountyLive Inc, L=San Francisco, ST=CA, C=US"

    cat > android/key.properties << EOF
storePassword=$ks_pass
keyPassword=$ks_pass
keyAlias=bountylive
storeFile=../key.jks
EOF
    log_ok "Keystore generated at android/key.jks"
    log_ok "Key properties written to android/key.properties"
    log_info "Keystore password stored in android/key.properties (keep this file secure!)"
    log_warn "Set KEYSTORE_PASSWORD env var to use a custom password, or the auto-generated one is used."
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
    local target="${1:-all}"

    cd "$PROJECT_ROOT"
    check_flutter

    case "$target" in
        apk)
            clean_project
            get_dependencies
            build_apk
            ;;
        ipa)
            clean_project
            get_dependencies
            build_ipa
            ;;
        web)
            clean_project
            get_dependencies
            build_web
            ;;
        ios-notest)
            # Build without cleaning (faster iteration)
            build_ipa
            ;;
        keystore)
            create_keystore
            ;;
        all|*)
            clean_project
            get_dependencies
            build_all
            ;;
    esac
    log_ok "Build complete: $target"
}

main "$@"
