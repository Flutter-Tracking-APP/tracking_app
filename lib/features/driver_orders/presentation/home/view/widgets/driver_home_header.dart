import 'package:flutter/material.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class DriverHomeHeader extends StatelessWidget {
  const DriverHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 12,
        bottom: 12,
      ),
      child: Text(
        'Flowery rider',
        style: AppStyles.appTitle.copyWith(fontSize: 24),
      ),
    );
  }
}
