import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class ApplyDriverHeaderWidget extends StatelessWidget {
  const ApplyDriverHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.applyWelcomeTitle, style: AppStyles.bold20Inter),
        SizedBox(height: screenHeight * 0.008),
        Text(
          l10n.applyWelcomeSubtitle,
          style: AppStyles.regular14InterGreyHeight15,
        ),
      ],
    );
  }
}
