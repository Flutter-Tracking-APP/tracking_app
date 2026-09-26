import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/order_item_tile.dart';

class OrderItemsListView extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderItemsListView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.orderDetails,
            style: AppStyles.regular14InterW500,
          ),
          const SizedBox(height: 8),
          ...items.map((item) => OrderItemTile(item: item)),
        ],
      ),
    );
  }
}
