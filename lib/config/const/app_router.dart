import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/features/auth/presentation/login/view/login_view.dart';

abstract final class AppRoutes {
  static const splash = '/';

  static const login = '/login';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const LoginView();
        },
      ),
    ],
  );
}
