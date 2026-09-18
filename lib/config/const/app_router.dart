import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/view/login_view.dart';
import 'package:tracking_app/features/splash/presentation/view/splash_view.dart';
import 'package:tracking_app/handlers/home_view.dart';

abstract final class AppRoutes {
  static const splash = '/';

  static const login = '/login';
  static const home = '/home';
  static const forgetPassword = '/forgot-password';
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
          return SplashView();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return HomeView();
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<ForgetPasswordBloc>(),
            child: const ForgetPasswordView(),
          );
        },
        parentNavigatorKey: _rootNavigatorKey,
      ),
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginView(),
          );
        },
      ),
    ],
  );
}
