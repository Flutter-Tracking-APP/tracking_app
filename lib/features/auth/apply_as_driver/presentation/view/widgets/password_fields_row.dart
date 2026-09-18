import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';

class PasswordFieldsRow extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? Function(String?) validatorPassword;
  final String? Function(String?) validatorConfirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const PasswordFieldsRow({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.validatorPassword,
    required this.validatorConfirmPassword,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppTextField(
            label: l10n.passwordLabel,
            hint: l10n.passwordHint,
            controller: passwordController,
            obscureText: !isPasswordVisible,
            localizations: l10n,
            validator: validatorPassword,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.grey,
              ),
              onPressed: onTogglePassword,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppTextField(
            label: l10n.confirmPasswordLabel,
            hint: l10n.confirmPasswordHint,
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            localizations: l10n,
            validator: validatorConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.grey,
              ),
              onPressed: onToggleConfirmPassword,
            ),
          ),
        ),
      ],
    );
  }
}
