import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class OrderStatusBadge extends StatelessWidget {
  final bool isCompleted;
  final bool isCancelled;
  final String? customLabel;

  const OrderStatusBadge({
    super.key,
    required this.isCompleted,
    this.isCancelled = false,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isCancel = isCancelled;
    final color = isCancel ? AppColors.error : AppColors.success;
    final icon = isCancel ? Icons.cancel_outlined : Icons.check_circle_outline;
    final label =
        customLabel ??
        (isCancel ? localizations.cancelled : localizations.completed);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppStyles.regular12Inter.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
