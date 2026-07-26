import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/stream/screens/watch_stream_screen.dart';
import '../../features/bounty/screens/bounty_list_screen.dart';
import '../../features/bounty/screens/bounty_detail_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/marketplace/screens/marketplace_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/gamification/screens/leaderboard_screen.dart';
import '../../features/gamification/screens/achievements_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/bounty/screens/create_bounty_screen.dart';
import '../../features/stream/screens/livestream_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/streams/:id',
        name: 'watchStream',
        builder: (context, state) => WatchStreamScreen(
          streamId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/streams/:id/go-live',
        name: 'goLive',
        builder: (context, state) => LivestreamScreen(
          streamId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/bounties',
        name: 'bounties',
        builder: (context, state) => const BountyListScreen(),
      ),
      GoRoute(
        path: '/bounties/create',
        name: 'createBounty',
        builder: (context, state) => const CreateBountyScreen(),
      ),
      GoRoute(
        path: '/bounties/:id',
        name: 'bountyDetail',
        builder: (context, state) => BountyDetailScreen(
          bountyId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/profile/:username',
        name: 'profile',
        builder: (context, state) => ProfileScreen(
          username: state.pathParameters['username']!,
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/chat/:streamId',
        name: 'chat',
        builder: (context, state) => ChatScreen(
          streamId: state.pathParameters['streamId']!,
        ),
      ),
      GoRoute(
        path: '/marketplace',
        name: 'marketplace',
        builder: (context, state) => const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
  );

  ref.listen(authProvider, (previous, next) {
    if (previous?.valueOrNull?.isLoggedIn != next.valueOrNull?.isLoggedIn) {
      router.refresh();
    }
  });

  return router;
});
