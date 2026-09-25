import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_view_mixin.dart';
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

class _ChangePasswordViewState extends State<ChangePasswordView>
    with BaseViewMixin<ChangePasswordView, ChangePasswordCubit, BaseEvent> {
  late final ChangePasswordCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  ChangePasswordCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = getIt<ChangePasswordCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
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
                  _buildCurrentPasswordField(l10n),
                  const SizedBox(height: 16),
                  _buildNewPasswordField(l10n),
                  const SizedBox(height: 16),
                  _buildConfirmNewPasswordField(l10n),
                  const SizedBox(height: 28),
                  _buildSubmitButton(context, l10n),
                ],
              ),
            ),
          ),
        ),
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
      titleSpacing: 0,
    );
  }

  Widget _buildCurrentPasswordField(AppLocalizations l10n) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.isCurrentPasswordVisible != curr.isCurrentPasswordVisible,
      builder: (context, state) {
        return AppTextField(
          label: l10n.currentPasswordLabel,
          hint: l10n.currentPasswordHint,
          controller: _currentPasswordController,
          obscureText: !state.isCurrentPasswordVisible,
          localizations: l10n,
          validator: (val) =>
              FormValidator.validateRequired(val, l10n.emptyValidationError),
          suffixIcon: IconButton(
            icon: Icon(
              state.isCurrentPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.grey,
            ),
            onPressed: () {
              _cubit.doEvent(const ToggleCurrentPasswordVisibilityEvent());
            },
          ),
        );
      },
    );
  }

  Widget _buildNewPasswordField(AppLocalizations l10n) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.isNewPasswordVisible != curr.isNewPasswordVisible,
      builder: (context, state) {
        return AppTextField(
          label: l10n.newPasswordLabel,
          hint: l10n.newPasswordHint,
          controller: _newPasswordController,
          obscureText: !state.isNewPasswordVisible,
          localizations: l10n,
          validator: (val) => FormValidator.validatePasswordValue(
            val,
            l10n.emptyValidationError,
            l10n.weakPasswordError,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.isNewPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.grey,
            ),
            onPressed: () {
              _cubit.doEvent(const ToggleNewPasswordVisibilityEvent());
            },
          ),
        );
      },
    );
  }

  Widget _buildConfirmNewPasswordField(AppLocalizations l10n) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.isConfirmNewPasswordVisible != curr.isConfirmNewPasswordVisible,
      builder: (context, state) {
        return AppTextField(
          label: l10n.confirmNewPasswordLabel,
          hint: l10n.confirmNewPasswordHint,
          controller: _confirmNewPasswordController,
          obscureText: !state.isConfirmNewPasswordVisible,
          localizations: l10n,
          validator: (val) => FormValidator.validateConfirmPassword(
            val,
            _newPasswordController.text,
            l10n.emptyValidationError,
            l10n.passwordMismatchError,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.isConfirmNewPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.grey,
            ),
            onPressed: () {
              _cubit.doEvent(const ToggleConfirmNewPasswordVisibilityEvent());
            },
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, AppLocalizations l10n) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      buildWhen: (prev, curr) =>
          prev.changePasswordState.isLoading !=
          curr.changePasswordState.isLoading,
      builder: (context, state) {
        return SizedBox(
          width: screenWidth,
          height: 48,
          child: AppButton(
            text: l10n.updateButton,
            isLoading: state.changePasswordState.isLoading,
            onPressed: state.changePasswordState.isLoading ? null : _onSubmit,
          ),
        );
      },
    );
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = ChangePasswordParams(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmNewPassword: _confirmNewPasswordController.text,
    );

    _cubit.doEvent(SubmitChangePasswordEvent(params));
  }
}
