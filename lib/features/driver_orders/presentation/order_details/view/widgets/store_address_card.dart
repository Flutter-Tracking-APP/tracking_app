import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/utils/url_launcher_utils.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/whatsapp_icon.dart';

class StoreAddressCard extends StatelessWidget {
  final StoreAddressEntity store;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  const StoreAddressCard({
    super.key,
    required this.store,
    this.onCall,
    this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.pickupAddress,
            style: AppStyles.regular14InterW500,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              color: AppColors.white[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white[500]!.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.purpleBase,
                  child: const Icon(
                    Icons.local_florist,
                    color: AppColors.whiteBase,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name.isNotEmpty ? store.name : localizations.floweryStore,
                        style: AppStyles.regular13W500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              store.address.isNotEmpty
                                  ? store.address
                                  : localizations.pickupAddress,
                              style: AppStyles.regular12Inter,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_outlined, color: AppColors.purpleBase, size: 20),
                  onPressed: onCall ??
                      (store.phone != null && store.phone!.isNotEmpty
                          ? () => _handleCall(context)
                          : null),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const WhatsAppIcon(size: 20),
                  onPressed: onWhatsApp ??
                      ((store.whatsAppNumber != null && store.whatsAppNumber!.isNotEmpty) ||
                              (store.phone != null && store.phone!.isNotEmpty)
                          ? () => _handleWhatsApp(context)
                          : null),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCall(BuildContext context) async {
    if (store.phone == null || store.phone!.isEmpty) return;
    final success = await UrlLauncherUtils.launchPhoneCall(store.phone!);
    if (!success && context.mounted) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.callingNotSupported),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleWhatsApp(BuildContext context) async {
    final target = (store.whatsAppNumber != null && store.whatsAppNumber!.isNotEmpty)
        ? store.whatsAppNumber!
        : store.phone;
    if (target == null || target.isEmpty) return;
    final success = await UrlLauncherUtils.launchWhatsApp(target);
    if (!success && context.mounted) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.whatsappNotSupported),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
