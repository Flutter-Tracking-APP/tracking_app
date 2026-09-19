import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class VehicleInfoTile extends StatelessWidget {
  final String vehicleType;
  final String plateNumber;
  final VoidCallback onTap;

  const VehicleInfoTile({
    super.key,
    this.vehicleType = 'Car',
    this.plateNumber = '222',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.white[500]!, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 24,
              color: AppColors.purpleBase,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.vehicleInfoLabel,
                    style: AppStyles.medium16Inter.copyWith(
                      color: AppColors.blackBase,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$vehicleType • $plateNumber',
                    style: AppStyles.regular12Inter,
                  ),
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
