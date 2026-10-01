import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/extensions/validation_error_extension.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValidationError? Function(String?)? errorValidator;
  final String? validationPattern;
  final String? validationErrorMessage;
  final void Function(String)? onChange;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final AppLocalizations? localizations;

  AppTextField({
    super.key,
    required this.label,
    required this.hint,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    this.controller,
    this.validator,
    this.errorValidator,
    this.validationPattern,
    this.validationErrorMessage,
    this.onChange,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.localizations,
  })  : labelStyle = labelStyle ?? AppStyles.regular12Roboto,
        hintStyle = hintStyle ?? AppStyles.regular14Roboto {
    assert(
      !((validationPattern != null || validationErrorMessage != null) &&
          (validator != null || errorValidator != null)),
      "You can either provide a custom validator or provide the validation pattern and error.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: labelStyle,
        labelText: label,
        hintText: hint,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        errorMaxLines: 3,
      ),
      controller: controller,
      validator: (val) {
        if (errorValidator != null) {
          final err = errorValidator!(val);
          if (err != null) {
            return err.toLocalizedMessage(context);
          }
        }
        if (validator != null) {
          return validator!(val);
        }
        return defaultValidator(context, val);
      },
      onChanged: onChange,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
    );
  }

  String? defaultValidator(BuildContext context, String? input) {
    final l10n = localizations ?? AppLocalizations.of(context)!;
    if (input == null) {
      return l10n.generalValidationError;
    }

    if (input.isEmpty) {
      return l10n.emptyValidationError;
    }

    if (validationPattern != null &&
        !AppValidators.validate(validationPattern!, input)) {
      return validationErrorMessage;
    }

    return null;
  }
}
