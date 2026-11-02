import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class VehicleInfoTile extends StatelessWidget {
  final String? vehicleType;
  final String? plateNumber;
  final VoidCallback onTap;

  const VehicleInfoTile({
    super.key,
    this.vehicleType,
    this.plateNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white[500]!, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.vehicleInfoLabel,
                    style: AppStyles.bold20Inter.copyWith(fontSize: 16),
                  ),
                  if (vehicleType != null && vehicleType!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(vehicleType!, style: AppStyles.regular12Inter),
                  ],
                  if (plateNumber != null && plateNumber!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(plateNumber!, style: AppStyles.regular12Inter),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
