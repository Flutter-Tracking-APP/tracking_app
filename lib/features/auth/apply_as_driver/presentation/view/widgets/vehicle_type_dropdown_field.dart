import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';

class VehicleTypeDropdownField extends StatelessWidget {
  final List<VehicleTypeEntity> vehicleTypes;
  final VehicleTypeEntity? selectedVehicleType;
  final bool isLoading;
  final ValueChanged<VehicleTypeEntity?> onChanged;
  final FormFieldValidator<VehicleTypeEntity>? validator;
  final String? errorText;

  const VehicleTypeDropdownField({
    super.key,
    required this.vehicleTypes,
    required this.selectedVehicleType,
    required this.isLoading,
    required this.onChanged,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final effectiveValue = vehicleTypes.cast<VehicleTypeEntity?>().firstWhere(
      (e) => e?.id == selectedVehicleType?.id,
      orElse: () => null,
    );

    return DropdownButtonFormField<VehicleTypeEntity>(
      initialValue: effectiveValue,
      decoration: InputDecoration(
        labelText: l10n.vehicleTypeLabel,
        labelStyle: AppStyles.regular12Roboto,
        hintText: l10n.vehicleTypeSelectHint,
        hintStyle: AppStyles.regular14Roboto,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        errorText: errorText,
      ),
      items: vehicleTypes.map((type) {
        return DropdownMenuItem<VehicleTypeEntity>(
          value: type,
          child: Text(type.name, style: AppStyles.regular14InterW500),
        );
      }).toList(),
      onChanged: isLoading ? null : onChanged,
      validator: validator,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.keyboard_arrow_down, color: AppColors.blackBase),
    );
  }
}
