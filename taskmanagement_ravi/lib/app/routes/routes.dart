import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/tasks/presentation/screens/home_screen.dart';
import '../../features/tasks/presentation/screens/splash.dart';
import 'custom_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateStream = ref.watch(authStateProvider.stream);
  final refresh = GoRouterRefreshStream(authStateStream);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/splash';
      final authState = ref.read(authStateProvider);

      return authState.when(
        data: (user) {
          if (isSplash) {
            return user == null ? '/login' : '/home';
          }

          final isLoggingIn = state.matchedLocation == '/login';
          final isSigningUp = state.matchedLocation == '/signup';

          if (user == null) {
            return isLoggingIn || isSigningUp ? null : '/login';
          } else {
            return isLoggingIn || isSigningUp ? '/home' : null;
          }
        },
        loading: () => isSplash ? null : '/splash',
        error: (_, __) => '/login',
      );
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, _) => const SignUpScreen()),
      GoRoute(path: '/home', builder: (context, _) => const HomeScreen()),
    ],
  );
});
