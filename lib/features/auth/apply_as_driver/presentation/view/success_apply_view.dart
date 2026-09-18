import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/success_waves_painter.dart';

class SuccessApplyView extends StatelessWidget {
  const SuccessApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.blackBase,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: size.height * 0.28,
            child: const CustomPaint(painter: SuccessWavesPainter()),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: size.width * 0.08,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.08),
                  _buildSuccessBadge(),
                  SizedBox(height: size.height * 0.04),
                  _buildContent(l10n),
                  SizedBox(height: size.height * 0.04),
                  _buildLoginButton(context, size, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBadge() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.purpleBase, width: 5),
      ),
      child: const Center(
        child: Icon(Icons.check, color: AppColors.purpleBase, size: 65),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.successApplyHeadline,
          textAlign: TextAlign.center,
          style: AppStyles.bold20Inter,
        ),
        const SizedBox(height: 12),
        Text(
          l10n.successApplyBody,
          textAlign: TextAlign.center,
          style: AppStyles.regular14InterGreyHeight15,
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    Size size,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: size.width,
      height: 48,
      child: AppButton(
        text: l10n.loginButton,
        onPressed: () => context.go(AppRoutes.login),
      ),
    );
  }
}
