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

  /// Whether the app is in debug mode
  static bool get isDebug => const bool.fromEnvironment('dart.vm.product') == false;

  /// Application name
  static const String appName = 'BountyLive';

  /// Application version
  static const String appVersion = '1.0.0';
}
