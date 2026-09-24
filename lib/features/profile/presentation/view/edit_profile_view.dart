import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_view_mixin.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/form_validator/form_validator.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/gender_radio_group.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_state.dart';
import 'package:tracking_app/features/profile/presentation/view/widgets/edit_profile_avatar.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileEntity? initialProfile;

  const EditProfileView({super.key, this.initialProfile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with BaseViewMixin<EditProfileView, EditProfileCubit> {
  late final EditProfileCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordPlaceholderController;

  late String _initialFirstName;
  late String _initialLastName;
  late String _initialPhone;
  late int _initialGender;

  @override
  EditProfileCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = getIt<EditProfileCubit>();
    if (widget.initialProfile != null) {
      _cubit.doEvent(InitEditProfileEvent(widget.initialProfile!));
    }

    _initialFirstName = widget.initialProfile?.firstName ?? '';
    _initialLastName = widget.initialProfile?.lastName ?? '';
    _initialPhone = widget.initialProfile?.phoneNumber ?? '';
    _initialGender = widget.initialProfile?.gender ?? 0;

    _firstNameController = TextEditingController(text: _initialFirstName)
      ..addListener(_onFieldChanged);
    _lastNameController = TextEditingController(text: _initialLastName)
      ..addListener(_onFieldChanged);
    _emailController = TextEditingController(
      text: widget.initialProfile?.email ?? '',
    );
    _phoneController = TextEditingController(text: _initialPhone)
      ..addListener(_onFieldChanged);
    _passwordPlaceholderController = TextEditingController(text: '••••••••');
    super.initState();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void handleEvent(BaseEvent event) {
    if (event is DisplaySuccess) {
      showSuccessSnackBar(event.successMsg);
      final updatedProfile = UserProfileEntity(
        id: widget.initialProfile?.id ?? '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: widget.initialProfile?.email ?? '',
        phoneNumber: _phoneController.text.trim(),
        gender: _cubit.state.selectedGender,
        profilePictureUrl: widget.initialProfile?.profilePictureUrl,
      );

      final goRouter = GoRouter.maybeOf(context);
      if (goRouter != null) {
        goRouter.pop(updatedProfile);
      } else {
        Navigator.of(context).pop(updatedProfile);
      }
      return;
    }
    super.handleEvent(event);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordPlaceholderController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final isDirty = _checkIsDirty(state);
          final isValid = _isFormValid();
          final canSubmit =
              isDirty && isValid && !state.updateProfileState.isLoading;

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
                      EditProfileAvatar(
                        localImage: state.avatarFile,
                        networkUrl: widget.initialProfile?.profilePictureUrl,
                        onPickImage: () =>
                            _cubit.doEvent(const PickAvatarEvent()),
                      ),
                      const SizedBox(height: 20),
                      _buildInputFields(l10n, context),
                      const SizedBox(height: 16),
                      GenderRadioGroup(
                        selectedGender: state.selectedGender,
                        onChanged: (gender) {
                          _cubit.doEvent(SelectEditGenderEvent(gender));
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSubmitButton(context, state, l10n, canSubmit),
                      const SizedBox(height: 20),
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
      title: Text(l10n.editProfileTitle, style: AppStyles.bold20Inter),
      centerTitle: false,
      titleSpacing: 0,
    );
  }

  Widget _buildInputFields(AppLocalizations l10n, BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                label: l10n.firstNameLabel,
                hint: l10n.firstNameHint,
                controller: _firstNameController,
                localizations: l10n,
                validator: (val) => FormValidator.validateRequired(
                  val,
                  l10n.emptyValidationError,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: l10n.lastNameLabel,
                hint: l10n.lastNameHint,
                controller: _lastNameController,
                localizations: l10n,
                validator: (val) => FormValidator.validateRequired(
                  val,
                  l10n.emptyValidationError,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.emailLabel,
          hint: l10n.emailHint,
          controller: _emailController,
          readOnly: true,
          localizations: l10n,
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
        const SizedBox(height: 14),
        AppTextField(
          label: l10n.passwordLabel,
          hint: l10n.passwordHint,
          controller: _passwordPlaceholderController,
          readOnly: true,
          obscureText: true,
          localizations: l10n,
          suffixIcon: TextButton(
            onPressed: () => context.push(AppRoutes.changePassword),
            child: Text(
              l10n.changeButton,
              style: AppStyles.semiBold12Underline.copyWith(
                color: AppColors.purpleBase,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    EditProfileState state,
    AppLocalizations l10n,
    bool canSubmit,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: AppButton(
        text: l10n.updateButton,
        isLoading: state.updateProfileState.isLoading,
        onPressed: canSubmit ? () => _onSubmit(state) : null,
      ),
    );
  }

  void _onSubmit(EditProfileState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = UpdateProfileParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: state.selectedGender,
      profilePictureUrl: widget.initialProfile?.profilePictureUrl ?? 'mock_url',
    );

    _cubit.doEvent(SubmitEditProfileEvent(params));
  }

  bool _checkIsDirty(EditProfileState state) {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final gender = state.selectedGender;
    final hasNewAvatar = state.avatarFile != null;

    return firstName != _initialFirstName ||
        lastName != _initialLastName ||
        phone != _initialPhone ||
        gender != _initialGender ||
        hasNewAvatar;
  }

  bool _isFormValid() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
      return false;
    }
    return FormValidator.validate(FormValidator.phonePattern, phone);
  }
}
