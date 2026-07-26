/// Stub implementation of [hideSplash] for native platforms (Android, iOS).
///
/// This file is used when `dart:js_interop` is NOT available (native).
/// The splash is an HTML element in the Blade shell, so there's nothing
/// to hide on native — this is a no-op.
///
/// See [splash_interop.dart] for the web implementation.
void hideSplash() {}
