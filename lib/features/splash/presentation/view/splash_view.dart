import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/splash/presentation/view/splash_driver_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _isNavigating = false;

  Future<void> _checkSession() async {
    if (_isNavigating) return;

    _isNavigating = true;

    final sessionService = getIt<SessionService>();

    try {
      final isRemembered = await sessionService.isRemembered();

      if (!mounted) return;

      if (isRemembered) {
        context.go(AppRoutes.profile);
      } else {
        context.go(AppRoutes.onBoarding);
      }
    } catch (_) {
      if (!mounted) return;

      context.go(AppRoutes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashDriverView(
        onFinished: _checkSession,
      ),
    );
  }
}
