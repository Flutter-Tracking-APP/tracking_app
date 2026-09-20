import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/form_validator/form_validator.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChangePasswordCubit>(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listenWhen: (prev, curr) =>
            prev.changePasswordState != curr.changePasswordState,
        listener: _handleListener,
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;

          return Scaffold(
            backgroundColor: AppColors.whiteBase,
            appBar: _buildAppBar(context, l10n),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildCurrentPasswordField(context, state, l10n),
                      const SizedBox(height: 16),
                      _buildNewPasswordField(context, state, l10n),
                      const SizedBox(height: 16),
                      _buildConfirmNewPasswordField(context, state, l10n),
                      const SizedBox(height: 28),
                      _buildSubmitButton(context, state, l10n),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(l10n.changePasswordTitle, style: AppStyles.bold20Inter),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
    );
  }

  Widget _buildCurrentPasswordField(
    BuildContext context,
    ChangePasswordState state,
    AppLocalizations l10n,
  ) {
    return AppTextField(
      label: l10n.currentPasswordLabel,
      hint: l10n.currentPasswordHint,
      controller: _currentPasswordController,
      obscureText: !state.isCurrentPasswordVisible,
      localizations: l10n,
      validator: (val) => _validateRequired(val, l10n),
      suffixIcon: IconButton(
        icon: Icon(
          state.isCurrentPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.grey,
        ),
        onPressed: () {
          context.read<ChangePasswordCubit>().doEvent(
            const ToggleCurrentPasswordVisibilityEvent(),
          );
        },
      ),
    );
  }

  Widget _buildNewPasswordField(
    BuildContext context,
    ChangePasswordState state,
    AppLocalizations l10n,
  ) {
    return AppTextField(
      label: l10n.newPasswordLabel,
      hint: l10n.newPasswordHint,
      controller: _newPasswordController,
      obscureText: !state.isNewPasswordVisible,
      localizations: l10n,
      validator: (val) => _validatePassword(val, l10n),
      suffixIcon: IconButton(
        icon: Icon(
          state.isNewPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.grey,
        ),
        onPressed: () {
          context.read<ChangePasswordCubit>().doEvent(
            const ToggleNewPasswordVisibilityEvent(),
          );
        },
      ),
    );
  }

  Widget _buildConfirmNewPasswordField(
    BuildContext context,
    ChangePasswordState state,
    AppLocalizations l10n,
  ) {
    return AppTextField(
      label: l10n.confirmNewPasswordLabel,
      hint: l10n.confirmNewPasswordHint,
      controller: _confirmNewPasswordController,
      obscureText: !state.isConfirmNewPasswordVisible,
      localizations: l10n,
      validator: (val) => _validateConfirmPassword(val, l10n),
      suffixIcon: IconButton(
        icon: Icon(
          state.isConfirmNewPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.grey,
        ),
        onPressed: () {
          context.read<ChangePasswordCubit>().doEvent(
            const ToggleConfirmNewPasswordVisibilityEvent(),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    ChangePasswordState state,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: AppButton(
        text: l10n.updateButton,
        isLoading: state.changePasswordState.isLoading,
        onPressed: state.changePasswordState.isLoading
            ? null
            : () => _onSubmit(context, state),
      ),
    );
  }

  void _onSubmit(BuildContext context, ChangePasswordState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = ChangePasswordParams(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmNewPassword: _confirmNewPasswordController.text,
    );

    context.read<ChangePasswordCubit>().doEvent(
      SubmitChangePasswordEvent(params),
    );
  }

  void _handleListener(BuildContext context, ChangePasswordState state) {
    if (state.changePasswordState.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.changePasswordState.data!),
          backgroundColor: AppColors.success,
        ),
      );
      context.go(AppRoutes.login);
    } else if (state.changePasswordState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.changePasswordState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String? _validateRequired(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    return null;
  }

  String? _validatePassword(String? val, AppLocalizations l10n) {
    if (val == null || val.isEmpty) return l10n.emptyValidationError;
    final result = FormValidator.validatePassword(val);
    if (result is! Valid) return l10n.weakPasswordError;
    return null;
  }

  String? _validateConfirmPassword(String? val, AppLocalizations l10n) {
    if (val == null || val.isEmpty) return l10n.emptyValidationError;
    if (val != _newPasswordController.text) {
      return l10n.passwordMismatchError;
    }
    return null;
  }
}
