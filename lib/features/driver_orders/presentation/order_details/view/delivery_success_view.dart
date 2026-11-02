import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';

class DeliverySuccessView extends StatelessWidget {
  final VoidCallback? onDone;

  const DeliverySuccessView({super.key, this.onDone});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      appBar: AppBar(
        title: Text(localizations.success),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: size.width * 0.08,
            vertical: 24,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildSuccessBadge(),
              const SizedBox(height: 32),
              _buildTitle(localizations),
              const SizedBox(height: 12),
              _buildSubtitle(localizations),
              const Spacer(flex: 3),
              _buildDoneButton(context, localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBadge() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.success.withValues(alpha: 0.12),
      ),
      child: Center(
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(alpha: 0.25),
          ),
          child: Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.whiteBase,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations localizations) {
    return Text(
      localizations.thankYou,
      textAlign: TextAlign.center,
      style: AppStyles.bold20Inter.copyWith(
        color: AppColors.success,
        fontSize: 24,
      ),
    );
  }

  Widget _buildSubtitle(AppLocalizations localizations) {
    return Text(
      localizations.orderDeliveredSuccessfullyTitle,
      textAlign: TextAlign.center,
      style: AppStyles.bold20Inter.copyWith(
        color: AppColors.blackBase,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDoneButton(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: AppButton(
        text: localizations.done,
        onPressed: () {
          onDone?.call();
          try {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          } catch (_) {
            context.go(AppRoutes.home);
          }
        },
      ),
    );
  }
}
