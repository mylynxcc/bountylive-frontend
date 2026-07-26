/// Web implementation of [hideSplash] using `dart:js_interop`.
///
/// This file is conditionally imported when `dart:js_interop` is
/// available (web). The extern maps to the global `window.hideSplash()`
/// function defined in `resources/views/app.blade.php`.
///
/// See [splash_stub.dart] for the native no-op stub.
library;

import 'dart:js_interop';

/// Calls `window.hideSplash()` via JS interop.
/// The Dart function name matches the JS function name, so no @JS
/// annotation is needed — dart:js_interop maps it automatically
/// to globalThis.hideSplash().
external void hideSplash();
