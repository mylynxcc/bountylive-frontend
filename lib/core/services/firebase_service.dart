import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/env_config.dart';

/// Initializes Firebase for all platforms.
///
/// - **Web**: Uses explicit [FirebaseOptions] from [Environment] config constants.
/// - **Android / iOS**: Reads config automatically from
///   `google-services.json` / `GoogleService-Info.plist`.
/// - **macOS / Windows / Linux**: Falls back to default init (may need
///   additional platform-specific options in the future).
class FirebaseService {
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
  }
}
