/// BountyLive Environment Configuration
///
/// Update [Environment.apiBaseUrl] to point to your Laravel backend.
/// For local development with `php artisan serve`, the default is:
///   Android emulator: http://10.0.2.2:8080/api/v1
///   iOS simulator:    http://localhost:8080/api/v1
///   Chrome/web:       http://localhost:8080/api/v1
///   Physical device:  http://<your-ip>:8080/api/v1
///
/// For production, update to your production API URL.
///
/// For Docker deployment, use: http://localhost/api/v1

class Environment {
  /// Base URL for the BountyLive API
  /// Must NOT end with a slash
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api/v1',
  );

  /// LiveKit WebSocket URL for streaming
  static const String liveKitWsUrl = String.fromEnvironment(
    'LIVEKIT_WS_URL',
    defaultValue: 'ws://localhost:7881',
  );

  /// Stripe publishable key
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_KEY',
    defaultValue: 'pk_test_example',
  );

  /// Paystack public key
  static const String paystackPublicKey = String.fromEnvironment(
    'PAYSTACK_KEY',
    defaultValue: 'pk_test_example',
  );

  /// Firebase web configuration for FlutterFire initialization on Web platform
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyDC5vksFcIoV7cwH0CmuY_DBPSrYbtbWBQ',
  );

  static const String firebaseAuthDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: 'bountylive-75675.firebaseapp.com',
  );

  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'bountylive-75675',
  );

  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'bountylive-75675.firebasestorage.app',
  );

  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '406401186705',
  );

  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '1:406401186705:web:021c3b0adab502fe9c7830',
  );

  static const String firebaseMeasurementId = String.fromEnvironment(
    'FIREBASE_MEASUREMENT_ID',
    defaultValue: 'G-EWWFD97EPZ',
  );

  /// Whether the app is in debug mode
  static bool get isDebug => const bool.fromEnvironment('dart.vm.product') == false;

  /// Application name
  static const String appName = 'BountyLive';

  /// Application version
  static const String appVersion = '1.0.0';
}
