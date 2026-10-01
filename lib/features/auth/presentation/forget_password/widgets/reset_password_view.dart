import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/extensions/app_failure_extension.dart';
import 'package:tracking_app/core/ui/extensions/validation_error_extension.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value, BuildContext context) {
    return AppValidators.validatePasswordDetailed(value)
        ?.toLocalizedMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (!state.isLoading &&
            state.operation == ForgetPasswordOperation.resetPassword) {
          if ((state.errorMessage == null || state.errorMessage!.isEmpty) &&
              state.failure == null) {
            AppRouter.router.go(AppRoutes.login);
          } else {
            final msg = state.failure?.toLocalizedMessage(context) ??
                state.errorMessage ??
                '';
            if (msg.isNotEmpty) {
              _showSnackBar(context, msg);
            }
          }
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),

            Text(
              localizations.createNewPassword,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            AppTextField(
              label: localizations.newPassword,
              hint: localizations.enterNewPassword,
              controller: _passwordController,
              localizations: localizations,
              obscureText: _obscurePassword,
              validator: (value) => _validatePassword(value, context),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),

            const SizedBox(height: 20),

            AppTextField(
              label: localizations.confirmPassword,
              hint: localizations.confirmYourPassword,
              controller: _confirmPasswordController,
              localizations: localizations,
              obscureText: _obscureConfirmPassword,
              validator: (value) => AppValidators.validateConfirmPassword(
                value,
                _passwordController.text,
              )?.toLocalizedMessage(context),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),

            const SizedBox(height: 24),

            BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
              builder: (context, state) {
                final isLoading =
                    state.isLoading &&
                    state.operation == ForgetPasswordOperation.resetPassword;

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            context.read<ForgetPasswordBloc>().add(
                              ResetPasswordEvent(_passwordController.text),
                            );
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(localizations.resetPassword),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
