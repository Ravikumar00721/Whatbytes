import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    // debugLogDiagnostics: true,
    // redirect: (context, state) {
    //   final authAsync = ref.read(authStateProvider);
    //   final isLoggingIn = state.matchedLocation == '/login';
    //   final isSigningUp = state.matchedLocation == '/signup';
    //
    //   return authAsync.when(
    //     data: (user) {
    //       final isLoggedIn = user != null;
    //       if (!isLoggedIn && !(isLoggingIn || isSigningUp)) return '/login';
    //       if (isLoggedIn && (isLoggingIn || isSigningUp)) return '/home';
    //       return null;
    //     },
    //     loading: () => null,
    //     error: (_, __) => '/login',
    //   );
    // },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      // GoRoute(
      //   path: '/home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],
  );
});
