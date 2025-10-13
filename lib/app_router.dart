
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref.watch(authChangesProvider.stream)),
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashGate()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      ShellRoute(
        builder: (c, s, child) => child,
        routes: [
          GoRoute(path: '/feed', builder: (c, s) => const FeedPage()),
          GoRoute(path: '/matches', builder: (c, s) => const MatchesPage()),
          GoRoute(path: '/chats', builder: (c, s) => const ChatListPage()),
          GoRoute(path: '/profile', builder: (c, s) => const EditProfilePage()),
          GoRoute(path: '/settings', builder: (c, s) => const SettingsPage()),
        ],
      ),
    ],
    redirect: (c, s) {
      final loggedIn = authState.valueOrNull?.isLoggedIn == true;
      final loggingIn = s.fullPath == '/login';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && (s.fullPath == '/' || loggingIn)) return '/feed';
      return null;
    },
  );
});