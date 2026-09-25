import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/base/base_view_mixin.dart';
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

class _ApplyAsDriverViewState extends State<ApplyAsDriverView>
    with BaseViewMixin<ApplyAsDriverView, ApplyDriverCubit> {
  late final ApplyDriverCubit _cubit;

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  ApplyDriverCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = getIt<ApplyDriverCubit>()..doEvent(const GetVehicleTypesEvent());
    super.initState();
  }

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
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
        buildWhen: (prev, curr) =>
            prev.applyState.isLoading != curr.applyState.isLoading,
        builder: (context, state) {
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
                      _buildVehicleSection(l10n),
                      const SizedBox(height: 14),
                      _buildContactFields(l10n),
                      const SizedBox(height: 14),
                      _buildIdSection(l10n),
                      const SizedBox(height: 14),
                      _buildPasswordSection(l10n),
                      const SizedBox(height: 16),
                      _buildGenderSection(),
                      const SizedBox(height: 20),
                      _buildSubmitButton(context, l10n),
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
          validator: (val) =>
              FormValidator.validateRequired(val, l10n.emptyValidationError),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.lastNameLabel,
          hint: l10n.lastNameHint,
          controller: _lastNameController,
          localizations: l10n,
          validator: (val) =>
              FormValidator.validateRequired(val, l10n.emptyValidationError),
        ),
      ],
    );
  }

  Widget _buildVehicleSection(AppLocalizations l10n) {
    return BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
      buildWhen: (prev, curr) =>
          prev.vehicleTypesState != curr.vehicleTypesState ||
          prev.selectedVehicleType != curr.selectedVehicleType ||
          prev.licenceImage != curr.licenceImage,
      builder: (context, state) {
        return Column(
          children: [
            VehicleTypeDropdownField(
              vehicleTypes: state.vehicleTypesState.data ?? [],
              selectedVehicleType: state.selectedVehicleType,
              isLoading: state.vehicleTypesState.isLoading,
              validator: (val) => FormValidator.validateDropdown(
                val,
                l10n.vehicleTypeRequiredError,
              ),
              onChanged: (val) {
                if (val != null) {
                  _cubit.doEvent(SelectVehicleTypeEvent(val));
                }
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: l10n.vehicleNumberLabel,
              hint: l10n.vehicleNumberHint,
              controller: _vehicleNumberController,
              localizations: l10n,
              validator: (val) => FormValidator.validateRequired(
                val,
                l10n.emptyValidationError,
              ),
            ),
            const SizedBox(height: 14),
            FileUploadField(
              label: l10n.vehicleLicenseLabel,
              hint: l10n.vehicleLicenseHint,
              file: state.licenceImage,
              validator: (val) => FormValidator.validateFile(
                val,
                l10n.licenseImageRequiredError,
              ),
              onTap: () => _cubit.doEvent(const PickLicenceImageEvent()),
            ),
          ],
        );
      },
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
          validator: (val) => FormValidator.validateEmail(
            val,
            l10n.emptyValidationError,
            l10n.invalidEmailError,
          ),
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.phoneLabel,
          hint: l10n.phoneHint,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          localizations: l10n,
          validator: (val) => FormValidator.validatePhone(
            val,
            l10n.emptyValidationError,
            l10n.invalidPhoneError,
          ),
        ),
      ],
    );
  }

  Widget _buildIdSection(AppLocalizations l10n) {
    return BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
      buildWhen: (prev, curr) => prev.nidImage != curr.nidImage,
      builder: (context, state) {
        return Column(
          children: [
            AppTextField(
              label: l10n.nidLabel,
              hint: l10n.nidHint,
              controller: _nidController,
              keyboardType: TextInputType.number,
              localizations: l10n,
              validator: (val) => FormValidator.validateNationalId(
                val,
                l10n.emptyValidationError,
                l10n.nationalIdError,
              ),
            ),
            const SizedBox(height: 14),
            FileUploadField(
              label: l10n.nidImageLabel,
              hint: l10n.nidImageHint,
              file: state.nidImage,
              validator: (val) =>
                  FormValidator.validateFile(val, l10n.nidImageRequiredError),
              onTap: () => _cubit.doEvent(const PickNidImageEvent()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordSection(AppLocalizations l10n) {
    return BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
      buildWhen: (prev, curr) =>
          prev.isPasswordVisible != curr.isPasswordVisible ||
          prev.isConfirmPasswordVisible != curr.isConfirmPasswordVisible,
      builder: (context, state) {
        return PasswordFieldsRow(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          validatorPassword: (val) => FormValidator.validatePasswordValue(
            val,
            l10n.emptyValidationError,
            l10n.weakPasswordError,
          ),
          validatorConfirmPassword: (val) =>
              FormValidator.validateConfirmPassword(
                val,
                _passwordController.text,
                l10n.emptyValidationError,
                l10n.passwordMismatchError,
              ),
          isPasswordVisible: state.isPasswordVisible,
          isConfirmPasswordVisible: state.isConfirmPasswordVisible,
          onTogglePassword: () =>
              _cubit.doEvent(const TogglePasswordVisibilityEvent()),
          onToggleConfirmPassword: () =>
              _cubit.doEvent(const ToggleConfirmPasswordVisibilityEvent()),
        );
      },
    );
  }

  Widget _buildGenderSection() {
    return BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
      buildWhen: (prev, curr) => prev.selectedGender != curr.selectedGender,
      builder: (context, state) {
        return GenderRadioGroup(
          selectedGender: state.selectedGender,
          onChanged: (gender) => _cubit.doEvent(SelectGenderEvent(gender)),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, AppLocalizations l10n) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<ApplyDriverCubit, ApplyDriverState>(
      buildWhen: (prev, curr) =>
          prev.applyState.isLoading != curr.applyState.isLoading,
      builder: (context, state) {
        return SizedBox(
          width: screenWidth,
          height: 48,
          child: AppButton(
            text: l10n.continueButton,
            isLoading: state.applyState.isLoading,
            onPressed: state.applyState.isLoading
                ? null
                : () => _onSubmit(context, l10n),
          ),
        );
      },
    );
  }

  void _onSubmit(BuildContext context, AppLocalizations l10n) {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    final state = _cubit.state;
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

    _cubit.doEvent(SubmitApplyDriverEvent(params));
  }
}
