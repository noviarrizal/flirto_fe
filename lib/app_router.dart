import 'package:flirto_fe/features/auth/presentation/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/splash_gate.dart';
import 'features/auth/providers.dart';
import 'features/feed/presentation/feed_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashGate()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      GoRoute(path: '/feed', builder: (c, s) => const FeedPage()),
    ],
    redirect: (c, s) {
      final loggedIn = authState.isLoggedIn;
      final loggingIn = s.fullPath == '/login';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && (s.fullPath == '/' || loggingIn)) return '/feed';
      return null;
    },
  );
});