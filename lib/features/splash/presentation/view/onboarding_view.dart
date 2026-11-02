import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_images.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _imageSlideAnimation;
  late final Animation<double> _imageFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // SVG comes from LEFT
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _imageFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    // MUST be the same as DriverView
    final imageHeight = screenHeight * 0.45;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              SizedBox(
                height: imageHeight,
                width: double.infinity,
                child: FadeTransition(
                  opacity: _imageFadeAnimation,
                  child: SlideTransition(
                    position: _imageSlideAnimation,
                    child: Center(
                      child: Image.asset(
                        AppImages.clipPathgroup,
                        height: imageHeight * 0.75,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '${localizations.welcomeTo} \n ${localizations.floweryriderapp}',
                textAlign: TextAlign.left,
                style: AppStyles.medium20,
              ),

              const SizedBox(height: 24),

              // =====================================
              // LOGIN
              // =====================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.login);
                  },
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 16),

              // =====================================
              // APPLY NOW
              // =====================================
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.push(AppRoutes.applyDriver);
                  },
                  style: TextButton.styleFrom(side: const BorderSide()),
                  child: Text(localizations.applyNow),
                ),
              ),

              const Spacer(),

              // =====================================
              // VERSION
              // =====================================
              const SizedBox(
                width: double.infinity,
                child: Text('v 6.3.0 - (446)', textAlign: TextAlign.center),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
