import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_images.dart';

class SplashDriverView extends StatefulWidget {
  const SplashDriverView({
    super.key,
    required this.onFinished,
  });

  final VoidCallback onFinished;

  @override
  State<SplashDriverView> createState() => _SplashDriverViewState();
}

class _SplashDriverViewState extends State<SplashDriverView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;

  Timer? _exitTimer;
  bool _startedExit = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished();
      }
    });
  }

  void _onLottieLoaded(LottieComposition composition) {
    if (_startedExit) return;

    _startedExit = true;

    // Wait until the Lottie animation completes.
    _exitTimer = Timer(
      composition.duration,
      () {
        if (!mounted) return;

        _slideController.forward();
      },
    );
  }

  @override
  void dispose() {
    _exitTimer?.cancel();

    _slideController
      ..removeStatusListener((_) {})
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.purpleBase;

    final localizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final imageSize = screenHeight * 0.40;

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: RepaintBoundary(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -70,
            left: -70,
            child: RepaintBoundary(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Spacer(),

                  SizedBox(
                    height: imageSize,
                    width: double.infinity,
                    child: Center(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(1.2, 0),
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.easeInCubic,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withValues(alpha: 0.45),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    primaryColor.withValues(alpha: 0.1),
                                blurRadius: 35,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Lottie.asset(
                            AppImages.deliveryServiceImage,
                            width: imageSize * 0.88,
                            height: imageSize * 0.88,
                            fit: BoxFit.cover,

                            // Play ONLY one cycle.
                            repeat: false,

                            // Start exit when the Lottie composition ends.
                            onLoaded: _onLottieLoaded,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),

                  Text(
                    localizations.floweryriderapp,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor:
                            primaryColor.withValues(alpha: 0.15),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          primaryColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}