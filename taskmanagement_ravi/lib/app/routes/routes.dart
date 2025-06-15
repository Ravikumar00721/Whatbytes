import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/tasks/presentation/screens/home_screen.dart';
import '../../features/tasks/presentation/screens/splash.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
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
        loading: () {
          return isSplash ? null : '/splash';
        },
        error: (error, stackTrace) {
          return '/login';
        },
      );
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
