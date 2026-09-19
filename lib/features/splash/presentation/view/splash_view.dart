 
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
  static const _splashDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(_splashDuration);

    if (!mounted) return;

    final sessionService = getIt<SessionService>();

    try {
      final isRemembered = await sessionService.isRemembered();

      if (!mounted) return;

      if (isRemembered) {
        context.go(AppRoutes.profile);
      } else {
        context.go(AppRoutes.onBoarding);
      }
    } catch (error) {

      if (!mounted) return;

      context.go(AppRoutes.onBoarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashDriverView(),
    );
  }
}
 
