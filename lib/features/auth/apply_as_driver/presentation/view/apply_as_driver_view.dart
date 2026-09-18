import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/form_validator/form_validator.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_cubit.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_events.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_state.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/apply_driver_header_widget.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/file_upload_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/gender_radio_group.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/password_fields_row.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/vehicle_type_dropdown_field.dart';

class ApplyAsDriverView extends StatefulWidget {
  const ApplyAsDriverView({super.key});

  @override
  State<ApplyAsDriverView> createState() => _ApplyAsDriverViewState();
}

class _ApplyAsDriverViewState extends State<ApplyAsDriverView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _licenceError;
  String? _nidError;
  String? _vehicleTypeError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _vehicleNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ApplyDriverCubit>()..doEvent(const GetVehicleTypesEvent()),
      child: BlocConsumer<ApplyDriverCubit, ApplyDriverState>(
        listenWhen: (prev, curr) => prev.applyState != curr.applyState,
        listener: _handleStateChanges,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ApplyDriverHeaderWidget(),
                      const SizedBox(height: 18),
                      _buildNameFields(l10n),
                      const SizedBox(height: 14),
                      _buildVehicleSection(context, state, l10n),
                      const SizedBox(height: 14),
                      _buildContactFields(l10n),
                      const SizedBox(height: 14),
                      _buildIdSection(context, state, l10n),
                      const SizedBox(height: 14),
                      PasswordFieldsRow(
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        validatorPassword: (val) =>
                            _validatePassword(val, l10n),
                        validatorConfirmPassword: (val) =>
                            _validateConfirmPassword(val, l10n),
                        isPasswordVisible: state.isPasswordVisible,
                        isConfirmPasswordVisible:
                            state.isConfirmPasswordVisible,
                        onTogglePassword: () => context
                            .read<ApplyDriverCubit>()
                            .doEvent(const TogglePasswordVisibilityEvent()),
                        onToggleConfirmPassword: () =>
                            context.read<ApplyDriverCubit>().doEvent(
                              const ToggleConfirmPasswordVisibilityEvent(),
                            ),
                      ),
                      const SizedBox(height: 16),
                      GenderRadioGroup(
                        selectedGender: state.selectedGender,
                        onChanged: (gender) {
                          context.read<ApplyDriverCubit>().doEvent(
                            SelectGenderEvent(gender),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildSubmitButton(context, state, l10n),
                      const SizedBox(height: 24),
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
      title: Text(l10n.applyTitle, style: AppStyles.bold20Inter),
      titleSpacing: 0,
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.blackBase,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildNameFields(AppLocalizations l10n) {
    return Column(
      children: [
        AppTextField(
          label: l10n.firstNameLabel,
          hint: l10n.firstNameHint,
          controller: _firstNameController,
          localizations: l10n,
          validator: (val) => _validateRequired(val, l10n),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.lastNameLabel,
          hint: l10n.lastNameHint,
          controller: _lastNameController,
          localizations: l10n,
          validator: (val) => _validateRequired(val, l10n),
        ),
      ],
    );
  }

  Widget _buildVehicleSection(
    BuildContext context,
    ApplyDriverState state,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<ApplyDriverCubit>();
    return Column(
      children: [
        VehicleTypeDropdownField(
          vehicleTypes: state.vehicleTypesState.data ?? [],
          selectedVehicleType: state.selectedVehicleType,
          isLoading: state.vehicleTypesState.isLoading,
          errorText: _vehicleTypeError,
          onChanged: (val) {
            if (val != null) {
              setState(() => _vehicleTypeError = null);
              cubit.doEvent(SelectVehicleTypeEvent(val));
            }
          },
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.vehicleNumberLabel,
          hint: l10n.vehicleNumberHint,
          controller: _vehicleNumberController,
          localizations: l10n,
          validator: (val) => _validateRequired(val, l10n),
        ),
        const SizedBox(height: 14),
        FileUploadField(
          label: l10n.vehicleLicenseLabel,
          hint: l10n.vehicleLicenseHint,
          file: state.licenceImage,
          errorText: _licenceError,
          onTap: () => _pickFile(context, isLicence: true),
        ),
      ],
    );
  }

  Widget _buildContactFields(AppLocalizations l10n) {
    return Column(
      children: [
        AppTextField(
          label: l10n.emailLabel,
          hint: l10n.emailHint,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          localizations: l10n,
          validator: (val) => _validateEmail(val, l10n),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.phoneLabel,
          hint: l10n.phoneHint,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          localizations: l10n,
          validator: (val) => _validatePhone(val, l10n),
        ),
      ],
    );
  }

  Widget _buildIdSection(
    BuildContext context,
    ApplyDriverState state,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        AppTextField(
          label: l10n.nidLabel,
          hint: l10n.nidHint,
          controller: _nidController,
          keyboardType: TextInputType.number,
          localizations: l10n,
          validator: (val) => _validateNationalId(val, l10n),
        ),
        const SizedBox(height: 14),
        FileUploadField(
          label: l10n.nidImageLabel,
          hint: l10n.nidImageHint,
          file: state.nidImage,
          errorText: _nidError,
          onTap: () => _pickFile(context, isLicence: false),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    ApplyDriverState state,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: AppButton(
        text: l10n.continueButton,
        isLoading: state.applyState.isLoading,
        onPressed: state.applyState.isLoading
            ? null
            : () => _onSubmit(context, state, l10n),
      ),
    );
  }

  Future<void> _pickFile(
    BuildContext context, {
    required bool isLicence,
  }) async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      final file = File(picked.path);
      final cubit = context.read<ApplyDriverCubit>();
      if (isLicence) {
        setState(() => _licenceError = null);
        cubit.doEvent(PickLicenceImageEvent(file));
      } else {
        setState(() => _nidError = null);
        cubit.doEvent(PickNidImageEvent(file));
      }
    }
  }

  void _onSubmit(
    BuildContext context,
    ApplyDriverState state,
    AppLocalizations l10n,
  ) {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasLicence = state.licenceImage != null;
    final hasNid = state.nidImage != null;
    final hasVehicleType = state.selectedVehicleType != null;

    setState(() {
      _licenceError = hasLicence ? null : l10n.licenseImageRequiredError;
      _nidError = hasNid ? null : l10n.nidImageRequiredError;
      _vehicleTypeError = hasVehicleType ? null : l10n.vehicleTypeRequiredError;
    });

    if (!isFormValid || !hasLicence || !hasNid || !hasVehicleType) {
      return;
    }

    final params = ApplyDriverParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      gender: state.selectedGender,
      nid: _nidController.text.trim(),
      nidImage: state.nidImage!,
      vehicleTypeId: state.selectedVehicleType!.id,
      vehiclePlateNumber: _vehicleNumberController.text.trim(),
      vehicleCapacity: 4,
      licenceImage: state.licenceImage!,
      fcmToken: 'mock_fcm_token',
    );

    context.read<ApplyDriverCubit>().doEvent(SubmitApplyDriverEvent(params));
  }

  void _handleStateChanges(BuildContext context, ApplyDriverState state) {
    if (state.applyState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.applyState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (state.applyState.data != null) {
      context.push(AppRoutes.applyDriverSuccess);
    }
  }

  String? _validateRequired(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    return null;
  }

  String? _validateEmail(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    if (!FormValidator.validate(FormValidator.emailPattern, val.trim())) {
      return l10n.invalidEmailError;
    }
    return null;
  }

  String? _validatePhone(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    if (!FormValidator.validate(FormValidator.phonePattern, val.trim())) {
      return l10n.invalidPhoneError;
    }
    return null;
  }

  String? _validateNationalId(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    if (!RegExp(r'^\d{14}$').hasMatch(val.trim())) {
      return l10n.nationalIdError;
    }
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
    if (val != _passwordController.text) return l10n.passwordMismatchError;
    return null;
  }
}
