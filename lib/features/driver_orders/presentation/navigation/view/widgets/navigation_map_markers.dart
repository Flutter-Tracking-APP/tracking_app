import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_images.dart';

class DriverLocationMarkerWidget extends StatelessWidget {
  const DriverLocationMarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Image.asset(
        AppImages.clipPathgroup,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
      ),
    );
  }
}

class StoreMarkerWidget extends StatelessWidget {
  final String storeName;

  const StoreMarkerWidget({
    super.key,
    this.storeName = 'Flower',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.purpleBase,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_florist,
                color: AppColors.whiteBase,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  storeName,
                  style: const TextStyle(
                    color: AppColors.whiteBase,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.location_on,
          color: AppColors.purpleBase,
          size: 26,
        ),
      ],
    );
  }
}

class UserMarkerWidget extends StatelessWidget {
  final String label;

  const UserMarkerWidget({
    super.key,
    this.label = 'Apartment',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.purpleBase,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home,
                color: AppColors.whiteBase,
                size: 14,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.whiteBase,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.purpleBase,
              size: 26,
            ),
            Positioned(
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gps_fixed,
                  color: Colors.blueAccent,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
