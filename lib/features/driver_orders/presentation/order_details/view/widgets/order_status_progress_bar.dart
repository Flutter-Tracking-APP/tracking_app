import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class OrderStatusProgressBar extends StatelessWidget {
  final OrderFulfillmentStatus status;

  const OrderStatusProgressBar({super.key, required this.status});

  int get _activeStepsCount {
    return switch (status) {
      OrderFulfillmentStatus.accepted => 1,
      OrderFulfillmentStatus.arrivedAtPickup => 2,
      OrderFulfillmentStatus.picked => 3,
      OrderFulfillmentStatus.outForDelivery => 4,
      OrderFulfillmentStatus.delivered => 5,
    };
  }

  @override
  Widget build(BuildContext context) {
    const totalBars = 5;
    final activeCount = _activeStepsCount;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(totalBars, (index) {
          final isCompleted = index < activeCount;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsetsDirectional.only(
                end: index < totalBars - 1 ? 8 : 0,
              ),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success
                    : AppColors.white[500]!.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
