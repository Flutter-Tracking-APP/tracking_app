import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_images.dart';

class SplashDriverView extends StatefulWidget {
  const SplashDriverView({super.key});

  @override
  State<SplashDriverView> createState() => _SplashDriverViewState();
}

class _SplashDriverViewState extends State<SplashDriverView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _imageSlideAnimation;

  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
 
    _imageSlideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.8, 0)).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

 
    _animationTimer = Timer(const Duration(milliseconds: 4800), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.purpleBase;
     final localizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

 
    final imageHeight = screenHeight * 0.45;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
 
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha:0.08),
              ),
            ),
          ),
 
          Positioned(
            bottom: -70,
            left: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha:0.12),
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
                    height: imageHeight,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha:0.45),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha:0.1),
                              blurRadius: 35,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SlideTransition(
                          position: _imageSlideAnimation,
                          child: Lottie.asset(
                            AppImages.deliveryServiceImage,
                            width: imageHeight * 0.88,
                            height: imageHeight * 0.88,
                            fit: BoxFit.cover,
                            repeat: true,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 140),
                    Text(
                    localizations.floweryriderapp,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                        backgroundColor: primaryColor.withValues(alpha:  0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
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
