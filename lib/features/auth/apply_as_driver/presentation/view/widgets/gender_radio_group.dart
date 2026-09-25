import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';

class GenderRadioGroup extends StatelessWidget {
  final int selectedGender;
  final ValueChanged<int> onChanged;

  const GenderRadioGroup({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return RadioGroup<int>(
      groupValue: selectedGender,
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
      child: Row(
        children: [
          Text(
            l10n.genderLabel,
            style: AppStyles.medium16Inter.copyWith(color: AppColors.blackBase),
          ),
          SizedBox(width: screenWidth * 0.04),
          _buildRadioOption(label: l10n.genderFemale, value: 1),
          SizedBox(width: screenWidth * 0.03),
          _buildRadioOption(label: l10n.genderMale, value: 0),
        ],
      ),
    );
  }

  Widget _buildRadioOption({required String label, required int value}) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<int>(value: value, activeColor: AppColors.purpleBase),
          Text(label, style: AppStyles.regular14InterW500),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
