import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';

// ── Platform-conditional JS interop: hide the HTML splash after first frame ──
// On web: calls window.hideSplash() via dart:js_interop
// On native: no-op (the splash is an HTML element, not a native splash screen)
import 'core/utils/splash_stub.dart'
    if (dart.library.js_interop) 'core/utils/splash_interop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUIOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: BountyLiveApp(),
    ),
  );

  // After the first frame renders, signal the HTML shell to hide
  // the splash screen. This creates a precise handshake:
  //   HTML shows splash → Flutter boots → first frame renders →
  //   hideSplash() called → splash fades out
  // No timeouts, no polling — just a clean render-ready signal.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    hideSplash();
  });
}

class BountyLiveApp extends ConsumerWidget {
  const BountyLiveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeAsync = ref.watch(themeModeProvider);

    return themeAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => MaterialApp.router(
        routerConfig: router,
        theme: BountyLiveTheme.darkTheme,
      ),
      data: (isDarkMode) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'BountyLive',
              debugShowCheckedModeBanner: false,
              theme: BountyLiveTheme.lightTheme,
              darkTheme: BountyLiveTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}

class _BountyLiveAppState extends ConsumerState<BountyLiveApp> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
