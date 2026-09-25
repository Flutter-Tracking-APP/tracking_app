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
    with BaseViewMixin<EditProfileView, EditProfileCubit, BaseEvent> {
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

    _firstNameController = TextEditingController(text: _initialFirstName);
    _lastNameController = TextEditingController(text: _initialLastName);
    _emailController = TextEditingController(
      text: widget.initialProfile?.email ?? '',
    );
    _phoneController = TextEditingController(text: _initialPhone);
    _passwordPlaceholderController = TextEditingController(text: '••••••••');
    super.initState();
  }

  @override
  void showSuccessSnackBar(String message) {
    super.showSuccessSnackBar(message);
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
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordPlaceholderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<EditProfileCubit>(
      create: (context) => _cubit,
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
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                    buildWhen: (prev, curr) =>
                        prev.avatarFile != curr.avatarFile,
                    builder: (context, state) {
                      return EditProfileAvatar(
                        localImage: state.avatarFile,
                        networkUrl: widget.initialProfile?.profilePictureUrl,
                        onPickImage: () =>
                            _cubit.doEvent(const PickAvatarEvent()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildInputFields(l10n, context),
                  const SizedBox(height: 16),
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedGender != curr.selectedGender,
                    builder: (context, state) {
                      return GenderRadioGroup(
                        selectedGender: state.selectedGender,
                        onChanged: (gender) {
                          _cubit.doEvent(SelectEditGenderEvent(gender));
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _EditProfileSubmitButton(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    phoneController: _phoneController,
                    initialFirstName: _initialFirstName,
                    initialLastName: _initialLastName,
                    initialPhone: _initialPhone,
                    initialGender: _initialGender,
                    onSubmit: _onSubmit,
                  ),
                  const SizedBox(height: 20),
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

  void _onSubmit(EditProfileState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = UpdateProfileParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: state.selectedGender,
      profilePicture: state.avatarFile,
    );

    _cubit.doEvent(SubmitEditProfileEvent(params));
  }
}

class _EditProfileSubmitButton extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final String initialFirstName;
  final String initialLastName;
  final String initialPhone;
  final int initialGender;
  final void Function(EditProfileState state) onSubmit;

  const _EditProfileSubmitButton({
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialPhone,
    required this.initialGender,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        firstNameController,
        lastNameController,
        phoneController,
      ]),
      builder: (context, _) {
        return BlocBuilder<EditProfileCubit, EditProfileState>(
          buildWhen: (prev, curr) =>
              prev.selectedGender != curr.selectedGender ||
              prev.avatarFile != curr.avatarFile ||
              prev.updateProfileState != curr.updateProfileState,
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            final isDirty = _checkIsDirty(state);
            final isValid = _isFormValid();
            final canSubmit =
                isDirty && isValid && !state.updateProfileState.isLoading;

            final screenWidth = MediaQuery.sizeOf(context).width;
            return SizedBox(
              width: screenWidth,
              height: 48,
              child: AppButton(
                text: l10n.updateButton,
                isLoading: state.updateProfileState.isLoading,
                onPressed: canSubmit ? () => onSubmit(state) : null,
              ),
            );
          },
        );
      },
    );
  }

  bool _checkIsDirty(EditProfileState state) {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final gender = state.selectedGender;
    final hasNewAvatar = state.avatarFile != null;

    return firstName != initialFirstName ||
        lastName != initialLastName ||
        phone != initialPhone ||
        gender != initialGender ||
        hasNewAvatar;
  }

  bool _isFormValid() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || phone.isEmpty) {
      return false;
    }
    return FormValidator.validate(FormValidator.phonePattern, phone);
  }
}
