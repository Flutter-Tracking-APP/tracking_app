import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: AppColors.white[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.white[500]!.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: item.image != null && item.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.white[500]!.withValues(alpha: 0.2),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.local_florist,
                        color: AppColors.purpleBase,
                      ),
                    )
                  : const Icon(
                      Icons.local_florist,
                      color: AppColors.purpleBase,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.isNotEmpty ? item.title : localizations.flowerOrder,
                  style: AppStyles.regular13W500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${localizations.egp} ${item.price}',
                  style: AppStyles.regular12Roboto.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackBase,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X${item.quantity}',
            style: AppStyles.regular13W500.copyWith(
              color: AppColors.purpleBase,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
