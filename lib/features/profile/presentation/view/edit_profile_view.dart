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

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordPlaceholderController;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.initialProfile?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.initialProfile?.lastName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialProfile?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialProfile?.phoneNumber ?? '',
    );
    _passwordPlaceholderController = TextEditingController(text: '••••••••');
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
    return BlocProvider(
      create: (_) {
        final cubit = getIt<EditProfileCubit>();
        if (widget.initialProfile != null) {
          cubit.doEvent(InitEditProfileEvent(widget.initialProfile!));
        }
        return cubit;
      },
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listenWhen: (prev, curr) =>
            prev.updateProfileState != curr.updateProfileState,
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
                      EditProfileAvatar(
                        localImage: state.avatarFile,
                        networkUrl: widget.initialProfile?.profilePictureUrl,
                        onPickImage: () => _pickImage(context),
                      ),
                      const SizedBox(height: 20),
                      _buildInputFields(l10n, context),
                      const SizedBox(height: 16),
                      GenderRadioGroup(
                        selectedGender: state.selectedGender,
                        onChanged: (gender) {
                          context.read<EditProfileCubit>().doEvent(
                            SelectEditGenderEvent(gender),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSubmitButton(context, state, l10n),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
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
                validator: (val) => _validateRequired(val, l10n),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: l10n.lastNameLabel,
                hint: l10n.lastNameHint,
                controller: _lastNameController,
                localizations: l10n,
                validator: (val) => _validateRequired(val, l10n),
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
          validator: (val) => _validatePhone(val, l10n),
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
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: AppButton(
        text: l10n.updateButton,
        isLoading: state.updateProfileState.isLoading,
        onPressed: state.updateProfileState.isLoading
            ? null
            : () => _onSubmit(context, state),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      context.read<EditProfileCubit>().doEvent(
        PickAvatarEvent(File(picked.path)),
      );
    }
  }

  void _onSubmit(BuildContext context, EditProfileState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = UpdateProfileParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: state.selectedGender,
      profilePictureUrl: widget.initialProfile?.profilePictureUrl ?? 'mock_url',
    );

    context.read<EditProfileCubit>().doEvent(SubmitEditProfileEvent(params));
  }

  void _handleListener(BuildContext context, EditProfileState state) {
    if (state.updateProfileState.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.updateProfileState.data!),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else if (state.updateProfileState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.updateProfileState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String? _validateRequired(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    return null;
  }

  String? _validatePhone(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    if (!FormValidator.validate(FormValidator.phonePattern, val.trim())) {
      return l10n.invalidPhoneError;
    }
    return null;
  }
}
