import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/apply_as_driver_view.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/success_apply_view.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/view/login_view.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/presentation/view/change_password_view.dart';
import 'package:tracking_app/features/profile/presentation/view/edit_profile_view.dart';
import 'package:tracking_app/features/profile/presentation/view/edit_vehicle_info_view.dart';
import 'package:tracking_app/features/profile/presentation/view/profile_view.dart';
import 'package:tracking_app/features/splash/presentation/view/onboarding_view.dart';
import 'package:tracking_app/features/splash/presentation/view/splash_view.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const applyDriver = '/apply-driver';
  static const applyDriverSuccess = '/apply-driver-success';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const editVehicleInfo = '/edit-vehicle-info';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const forgetPassword = '/forgot-password';
  static const onBoarding = '/onBoarding';
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
        path: AppRoutes.onBoarding,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return OnboardingView();
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
      GoRoute(
        path: AppRoutes.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const ProfileView();
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final profile = state.extra as UserProfileEntity?;
          return EditProfileView(initialProfile: profile);
        },
      ),
      GoRoute(
        path: AppRoutes.editVehicleInfo,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const EditVehicleInfoView();
        },
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const ChangePasswordView();
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
      GoRoute(
        path: AppRoutes.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const ProfileView();
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final profile = state.extra as UserProfileEntity?;
          return EditProfileView(initialProfile: profile);
        },
      ),
      GoRoute(
        path: AppRoutes.editVehicleInfo,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const EditVehicleInfoView();
        },
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const ChangePasswordView();
        },
      ),
    ],
  );
}
