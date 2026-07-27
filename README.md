<div align="center">
  <br />
  <a href="https://github.com/mylynxcc/bountylive-frontend">
    <img src="https://img.shields.io/badge/BountyLive-6C63FF?style=for-the-badge&logo=flutter&logoColor=white" alt="BountyLive" />
  </a>
  <br />
  <h1 align="center">🚀 BountyLive — Flutter Frontend</h1>
  <p align="center">
    A live challenge marketplace — stream, compete, and earn.
    <br />
    <a href="https://github.com/mylynxcc/bountylive-frontend"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#-features">Features</a>
    ·
    <a href="#-screens">Screens</a>
    ·
    <a href="#-architecture">Architecture</a>
    ·
    <a href="#-getting-started">Getting Started</a>
    ·
    <a href="#-tech-stack">Tech Stack</a>
  </p>
  <br />
</div>

---

## 📋 Overview

**BountyLive** is a real-time challenge marketplace where creators can broadcast live streams, issue bounties to their audience, and earn rewards. The frontend is built with **Flutter 3.7+** and follows a clean, feature-first architecture using **Riverpod** for state management and **GoRouter** for declarative navigation.

| Platform | Status |
|----------|--------|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | ✅ Supported |
| macOS | ✅ Supported |
| Windows | ✅ Supported |
| Linux | ✅ Supported |

---

## ✨ Features

### 📺 Live Streaming
- Go live with **LiveKit** WebRTC-powered streaming
- Real-time viewer count and stream controls (mic, camera, screen share)
- Watch streams with integrated chat overlay
- Stream reminders and notifications

### 🏆 Bounties (Challenges)
- **Create bounties** with prize pools, categories, and difficulty levels
- **Browse** trending and categorized bounties (Gaming, Sports, Cooking, Music, Art, Fitness)
- **Apply** to challenges and submit proof of completion
- Escrow-based prize distribution with dispute resolution

### 💰 Wallet & Payments
- Multi-currency wallet with locked/available balance tracking
- **Deposit, withdraw, and transfer** funds
- Stripe, Paystack, and Flutterwave payment gateway integration
- Transaction history with visual indicators

### 🎮 Gamification
- **Achievements system** with unlockable badges
- **Leaderboard** rankings across the community
- XP points, levels, and progression tracking
- Streak tracking and milestone rewards

### 💬 Real-time Chat
- Live stream chat with emoji picker and GIPHY integration
- Direct messaging between users
- Chat moderation tools

### 🔐 Authentication
- **Email/password** registration and login
- **Social login** — Google, Apple, Facebook
- Biometric authentication (Face ID / fingerprint)
- Secure token management with `flutter_secure_storage`
- Account types: Viewer, Creator, Bounty Master

### 🛍️ Marketplace
- Browse and purchase digital goods and services
- Product listings with images and descriptions
- Secure checkout with multiple payment options

### 🎨 Theming
- **Dark & Light mode** with smooth transitions
- Custom **Poppins** typography throughout
- **Glassmorphism** UI elements
- Gradient accents (primary, live, bounty)
- Animated micro-interactions (`flutter_animate`, `lottie`)

### 📱 Additional Features
- **Push notifications** via Firebase Cloud Messaging
- **In-app notifications** (follows, donations, achievements, stream reminders)
- **Search** with filters and categories
- **User profiles** with stats, bio, and activity feed
- **Profile editing** with image upload
- **Biometric lock** for sensitive screens
- **Deep linking** support via GoRouter
- **Responsive layout** using `flutter_screenutil`

---

## 📱 Screens

| Screen | Route | Description |
|--------|-------|-------------|
| **Home Feed** | `/` | Live streams, trending bounties, personalized feed |
| **Login** | `/login` | Email/password + social sign-in |
| **Register** | `/register` | Account creation with user type selection |
| **Watch Stream** | `/streams/:id` | Live stream player with chat |
| **Go Live** | `/streams/:id/go-live` | Broadcaster controls and stream setup |
| **Bounty List** | `/bounties` | Filterable list with category chips |
| **Bounty Detail** | `/bounties/:id` | Full bounty info, apply/submit |
| **Create Bounty** | `/bounties/create` | Bounty creation form with prize setup |
| **Wallet** | `/wallet` | Balance, deposit, withdraw, transactions |
| **Profile** | `/profile/:username` | User stats, bounties, activity |
| **Edit Profile** | `/profile/edit` | Avatar, bio, social links |
| **Marketplace** | `/marketplace` | Browse and purchase digital goods |
| **Chat** | `/chat/:streamId` | Real-time stream chat |
| **Notifications** | `/notifications` | All in-app notifications |
| **Settings** | `/settings` | Theme, notifications, account, privacy |
| **Search** | `/search` | Global search with filters |
| **Leaderboard** | `/leaderboard` | Top users by XP/reputation |
| **Achievements** | `/achievements` | Earned badges and progress |

---

## 🏗️ Architecture

```
lib/
├── main.dart                         # App entry point
├── core/
│   ├── config/
│   │   └── env_config.dart           # Environment variables & API config
│   ├── network/
│   │   └── api_client.dart           # Dio HTTP client with interceptors
│   ├── providers/
│   │   ├── auth_provider.dart        # Auth state management
│   │   └── theme_provider.dart       # Theme state management
│   ├── router/
│   │   └── app_router.dart           # GoRouter route definitions
│   ├── theme/
│   │   └── app_theme.dart            # Light/dark theme & color palette
│   └── utils/
│       ├── splash_interop.dart       # Web JS interop for splash fade
│       └── splash_stub.dart          # Native platform no-op stub
│
├── features/
│   ├── auth/                         # Authentication (login, register, social)
│   ├── bounty/                        # Bounties (list, detail, create)
│   ├── chat/                          # Live stream chat
│   ├── gamification/                  # Achievements & leaderboard
│   ├── home/                          # Main feed & bottom navigation
│   ├── marketplace/                   # Digital goods marketplace
│   ├── notifications/                 # Push & in-app notifications
│   ├── profile/                       # User profiles & editing
│   ├── search/                        # Global search
│   ├── settings/                      # App settings
│   ├── stream/                        # Live streaming (watch & broadcast)
│   └── wallet/                        # Wallet & payments
│
├── backend/                          # [Separate Laravel API repo]
│
assets/
├── images/                           # PNG, JPEG assets
├── icons/                            # SVG icons
├── fonts/                            # Poppins typeface (400-700 weight)
├── animations/                       # Lottie JSON animations
└── lottie/                           # Additional Lottie files
```

### State Management

The app uses **Riverpod** (`flutter_riverpod`) with `AsyncNotifierProvider` for reactive state:

- **`AuthNotifier`** — Manages login/register/logout, session restoration from secure storage, handles 401 token expiry
- **`ThemeModeNotifier`** — Persists dark/light mode preference to `SharedPreferences`
- **`apiClientProvider`** — Provides the configured Dio HTTP client as a singleton

### Networking Layer

The `ApiClient` class wraps **Dio** with automatic:
- **Auth interceptor** — Injects `Bearer` token on every request
- **Log interceptor** — Debug prints for API calls
- **Retry interceptor** — Automatic retry on timeouts with 2s delay
- **401 handler** — Clears expired tokens

### Navigation

**GoRouter** provides declarative, type-safe routing with:
- Named routes for type-safe navigation
- Auth state listeners for redirect logic
- Deep linking support
- Route-level code splitting potential

---

## 🛠️ Tech Stack

| Category | Library | Version |
|----------|---------|---------|
| **Framework** | Flutter | ^3.7.0 |
| **State Management** | Riverpod | ^2.6.1 |
| **Navigation** | GoRouter | ^14.8.1 |
| **HTTP Client** | Dio | ^5.7.0 |
| **API Client** | Retrofit | ^4.4.2 |
| **Streaming** | LiveKit Client | ^2.9.1 |
| **Video Player** | Video Player + Chewie | ^2.9.2 / ^1.10.0 |
| **Auth** | Firebase Auth, Google Sign-In, Apple Sign-In, Facebook Auth | latest |
| **Payments** | Stripe, Paystack, Flutterwave | latest |
| **Storage** | Flutter Secure Storage, Shared Preferences, Hive | latest |
| **Maps** | Flutter Map | ^7.0.2 |
| **Notifications** | Firebase Messaging, Local Notifications | latest |
| **UI** | Shimmer, Lottie, Flutter SVG, Flutter Animate, Glassmorphism | latest |
| **Images** | Cached Network Image, Photo View | latest |
| **Media** | Image Picker, File Picker, Image Compressor | latest |
| **Analytics** | Firebase Analytics | ^11.4.2 |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** ^3.7.0 ([install guide](https://docs.flutter.dev/get-started/install))
- **Dart** ^3.7.0 (bundled with Flutter)
- **Android Studio** or **Xcode** for platform builds
- A running instance of the [BountyLive Laravel backend](https://github.com/mylynxcc/bountylive-api)

### Installation

```bash
# Clone the repository
git clone https://github.com/mylynxcc/bountylive-frontend.git
cd bountylive-frontend

# Install dependencies
flutter pub get

# Run code generation (for JSON serializers, Hive adapters, etc.)
dart run build_runner build --delete-conflicting-outputs
```

### Environment Configuration

Configure your API endpoint and keys in `lib/core/config/env_config.dart` or pass them at build time:

```dart
// Default configuration (overridable via --dart-define)
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  static const String liveKitWsUrl = String.fromEnvironment(
    'LIVEKIT_WS_URL',
    defaultValue: 'ws://localhost:7881',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_KEY',
    defaultValue: 'pk_test_example',
  );
}
```

For platform-specific API URLs:

| Platform | Default API URL |
|----------|----------------|
| Android Emulator | `http://10.0.2.2:8080/api/v1` |
| iOS Simulator | `http://localhost:8080/api/v1` |
| Chrome (Web) | `http://localhost:8080/api/v1` |
| Physical Device | `http://<your-ip>:8080/api/v1` |
| Docker | `http://localhost/api/v1` |

### Running the App

```bash
# With custom API URL
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api/v1

# Release mode
flutter run --release

# Web build
cd scripts && ./build-web.sh
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires Xcode)
flutter build ios --release

# Web
cd scripts && ./release_build.sh
```

---

## 🔧 Development

### Code Generation

```bash
# Run code generators once
dart run build_runner build

# Watch mode (auto-generate on changes)
dart run build_runner watch
```

### Linting & Analysis

```bash
# Static analysis
flutter analyze

# Auto-format
dart format .
```

### Testing

```bash
# Run all tests
flutter test

# With coverage
flutter test --coverage
```

---

## 🤝 Backend API

BountyLive requires a Laravel backend API. The API is built separately and provides:

- **RESTful endpoints** for all CRUD operations
- **WebSocket support** via Laravel Reverb for real-time streaming and chat
- **Escrow-based** bounty prize management
- **File upload** handling for bounty submissions
- **Push notification** delivery

> The backend repository is maintained separately. Contact the maintainer for access.

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/) 💙
- State management by [Riverpod](https://riverpod.dev/)
- Streaming powered by [LiveKit](https://livekit.io/)
- Icons by [Material Design](https://materialdesignicons.com/)
- Animations by [Lottie](https://lottiefiles.com/)

---

<div align="center">
  <sub>Built with ❤️ by the BountyLive team</sub>
  <br />
  <sub>
    <a href="https://github.com/mylynxcc/bountylive-frontend/issues">Report Bug</a> ·
    <a href="https://github.com/mylynxcc/bountylive-frontend/issues">Request Feature</a>
  </sub>
</div>
