import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_status_badge.dart';

class OrderHistorySummaryCard extends StatelessWidget {
  final int count;
  final bool isCompleted;
  final bool isCancelled;

  const OrderHistorySummaryCard({
    super.key,
    required this.count,
    required this.isCompleted,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isCancelled
        ? AppColors.lightRed
        : AppColors.lightGreen;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count.toString(), style: AppStyles.bold20Inter),
          const SizedBox(height: 6),
          OrderStatusBadge(isCompleted: isCompleted, isCancelled: isCancelled),
        ],
      ),
    );
  }
}
