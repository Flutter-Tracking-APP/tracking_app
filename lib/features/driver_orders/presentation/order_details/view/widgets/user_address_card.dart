import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/utils/url_launcher_utils.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';
import 'package:tracking_app/features/driver_orders/presentation/order_details/view/widgets/whatsapp_icon.dart';

class UserAddressCard extends StatelessWidget {
  final UserAddressEntity user;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  const UserAddressCard({
    super.key,
    required this.user,
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
            localizations.userAddress,
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
                  backgroundColor: AppColors.pink10,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.purpleBase,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
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
                              user.address.isNotEmpty
                                  ? user.address
                                  : localizations.userAddress,
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
                      (user.phone != null && user.phone!.isNotEmpty
                          ? () => _handleCall(context)
                          : null),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const WhatsAppIcon(size: 20),
                  onPressed: onWhatsApp ??
                      (user.phone != null && user.phone!.isNotEmpty
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
    if (user.phone == null || user.phone!.isEmpty) return;
    final success = await UrlLauncherUtils.launchPhoneCall(user.phone!);
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
    if (user.phone == null || user.phone!.isEmpty) return;
    final success = await UrlLauncherUtils.launchWhatsApp(user.phone!);
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
