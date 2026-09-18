import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/apply_as_driver_view.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/success_apply_view.dart';
import 'package:tracking_app/features/auth/presentation/login/view/login_view.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const applyDriver = '/apply-driver';
  static const applyDriverSuccess = '/apply-driver-success';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.applyDriver,
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
      GoRoute(
        path: AppRoutes.applyDriver,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const ApplyAsDriverView();
        },
      ),
      GoRoute(
        path: AppRoutes.applyDriverSuccess,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const SuccessApplyView();
        },
      ),
    ],
  );
}
