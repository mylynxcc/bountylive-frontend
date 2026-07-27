import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/env_config.dart';

/// Initializes Firebase for all platforms and enables
/// Analytics + Crashlytics from the very first launch.
///
/// - **Web**: Uses explicit [FirebaseOptions] from [Environment] config constants.
/// - **Android / iOS**: Reads config automatically from
///   `google-services.json` / `GoogleService-Info.plist`.
/// - **macOS / Windows / Linux**: Falls back to default init (may need
///   additional platform-specific options in the future).
class FirebaseService {
  /// Shared Analytics instance for manual event logging throughout the app.
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// Shared Crashlytics instance for recording fatal & non-fatal errors.
  static final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  /// Initialises Firebase core and enables Analytics + Crashlytics.
  /// Call this once from `main()` after `WidgetsFlutterBinding.ensureInitialized()`.
  static Future<void> initialize() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: Environment.firebaseApiKey,
          authDomain: Environment.firebaseAuthDomain,
          projectId: Environment.firebaseProjectId,
          storageBucket: Environment.firebaseStorageBucket,
          messagingSenderId: Environment.firebaseMessagingSenderId,
          appId: Environment.firebaseAppId,
          measurementId: Environment.firebaseMeasurementId,
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    // ── Analytics ──────────────────────────────────────────────
    // On mobile, Analytics is collected automatically via the native SDKs.
    // On web, screen views and events are logged through the JS SDK.
    // Set this to `false` only if the user has explicitly opted out.
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    // ── Crashlytics ────────────────────────────────────────────
    // Pass all Flutter errors (including those caught by runZonedGuarded)
    // through to Crashlytics so every crash is recorded.
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Catch errors thrown outside the Flutter widget tree.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Enable Crashlytics collection.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Log a sentinel event so the first-crash report includes a session start.
    await FirebaseCrashlytics.instance.recordError(
      'FirebaseService.initialize() — session started',
      StackTrace.current,
      fatal: false,
      information: ['App launched: ${Environment.appVersion}'],
    );
  }
}
