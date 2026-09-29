import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_status_badge.dart';

class HistoricalOrderStatusHeader extends StatelessWidget {
  final bool isCompleted;
  final bool isCancelled;
  final String orderNumber;

  const HistoricalOrderStatusHeader({
    super.key,
    required this.isCompleted,
    this.isCancelled = false,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OrderStatusBadge(isCompleted: isCompleted, isCancelled: isCancelled),
          Text(
            '# $orderNumber',
            style: AppStyles.regular13W500.copyWith(color: AppColors.blackBase),
          ),
        ],
      ),
    );
  }
}
