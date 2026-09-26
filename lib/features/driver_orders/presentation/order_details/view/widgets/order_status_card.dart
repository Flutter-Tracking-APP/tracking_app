import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class OrderStatusCard extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderStatusCard({super.key, required this.order});

  String _statusLabel(BuildContext context, OrderFulfillmentStatus status) {
    final localizations = AppLocalizations.of(context)!;
    return switch (status) {
      OrderFulfillmentStatus.accepted ||
      OrderFulfillmentStatus.arrivedAtPickup =>
        localizations.statusAccepted,
      OrderFulfillmentStatus.picked => localizations.statusPicked,
      OrderFulfillmentStatus.outForDelivery =>
        localizations.statusOutForDelivery,
      OrderFulfillmentStatus.arrived => localizations.statusArrived,
      OrderFulfillmentStatus.delivered => localizations.statusDelivered,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final statusText = _statusLabel(context, order.status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizations.status} : $statusText',
            style: AppStyles.regular14InterW500.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${localizations.orderId} : # ${order.orderNumber}',
            style: AppStyles.medium16Roboto.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (order.formattedDate != null && order.formattedDate!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              order.formattedDate!,
              style: AppStyles.regular12Inter,
            ),
          ],
        ],
      ),
    );
  }
}
