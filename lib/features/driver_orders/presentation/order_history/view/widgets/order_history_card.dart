import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/store_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/user_address_card.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_history/view/widgets/order_status_badge.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderHistoryEntity order;
  final VoidCallback? onTap;

  const OrderHistoryCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsetsDirectional.all(14),
        decoration: BoxDecoration(
          color: AppColors.white[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.white[500]!.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.flowerOrder,
                  style: AppStyles.regular13W500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '# ${order.orderNumber}',
                  style: AppStyles.regular13W500.copyWith(
                    color: AppColors.blackBase,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            OrderStatusBadge(
              isCompleted: order.isCompleted,
              isCancelled: order.isCancelled,
            ),
            const SizedBox(height: 10),
            StoreAddressCard(
              store: order.store,
              showActions: false,
              padding: const EdgeInsetsDirectional.only(bottom: 8),
            ),
            UserAddressCard(
              user: order.user,
              showActions: false,
              padding: EdgeInsetsDirectional.zero,
            ),
          ],
        ),
      ),
    );
  }
}
