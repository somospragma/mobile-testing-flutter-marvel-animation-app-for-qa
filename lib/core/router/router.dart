import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marvel_animation_app/features/home/presentation/pages/main_page.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/maps/presentation/pages/maps_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';

// GoRouter configuration
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref<GoRouter> ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        name: 'splashScreen',
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'logIn',
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const LoginPage(),
      ),
      GoRoute(
        name: 'signUp',
        path: '/signUp',
        builder: (BuildContext context, GoRouterState state) => const SignUpPage(),
      ),
      GoRoute(
        name: 'main',
        path: '/main',
        builder: (BuildContext context, GoRouterState state) => const MainScreen(),
      ),
      GoRoute(
        name: 'resetPassword',
        path: '/resetPassword',
        builder: (BuildContext context, GoRouterState state) => const ResetPasswordPage(),
      ),
      GoRoute(
        name: 'map',
        path: '/map',
        builder: (BuildContext context, GoRouterState state) => const MapPage(),
      ),
    ],
  );
});
