import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => context.push(AppRoutes.applyDriver),
              child: Text(
                'Apply as Driver',
                style: AppStyles.medium16InterUnderline,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push(AppRoutes.profile),
              child: Text('Profile', style: AppStyles.medium16InterUnderline),
            ),
          ],
        ),
      ),
    );
  }
}
