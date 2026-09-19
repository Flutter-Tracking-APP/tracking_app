import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/const/app_colors.dart';
import 'package:tracking_app/core/const/app_styles.dart';
import 'package:tracking_app/core/ui/widgets/app_button.dart';
import 'package:tracking_app/core/ui/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/file_upload_field.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/view/widgets/vehicle_type_dropdown_field.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_cubit.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_state.dart';

class EditVehicleInfoView extends StatefulWidget {
  const EditVehicleInfoView({super.key});

  @override
  State<EditVehicleInfoView> createState() => _EditVehicleInfoViewState();
}

class _EditVehicleInfoViewState extends State<EditVehicleInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<EditVehicleCubit>()..doEvent(const LoadVehicleTypesEvent()),
      child: BlocConsumer<EditVehicleCubit, EditVehicleState>(
        listenWhen: (prev, curr) =>
            prev.updateVehicleState != curr.updateVehicleState,
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
                      VehicleTypeDropdownField(
                        vehicleTypes: state.vehicleTypesState.data ?? [],
                        selectedVehicleType: state.selectedVehicleType,
                        isLoading: state.vehicleTypesState.isLoading,
                        onChanged: (type) {
                          if (type != null) {
                            context.read<EditVehicleCubit>().doEvent(
                              SelectVehicleTypeEvent(type),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: l10n.vehicleNumberLabel,
                        hint: l10n.vehicleNumberHint,
                        controller: _plateNumberController,
                        localizations: l10n,
                        validator: (val) => _validateRequired(val, l10n),
                      ),
                      const SizedBox(height: 16),
                      FileUploadField(
                        label: l10n.vehicleLicenseLabel,
                        hint: l10n.vehicleLicenseHint,
                        file: state.licenseFile,
                        onTap: () => _pickLicense(context),
                      ),
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
      title: Text(l10n.editVehicleInfoTitle, style: AppStyles.bold20Inter),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    EditVehicleState state,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: screenWidth,
      height: 48,
      child: AppButton(
        text: l10n.updateButton,
        isLoading: state.updateVehicleState.isLoading,
        onPressed: state.updateVehicleState.isLoading
            ? null
            : () => _onSubmit(context, state),
      ),
    );
  }

  Future<void> _pickLicense(BuildContext context) async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      context.read<EditVehicleCubit>().doEvent(
        PickLicenseDocumentEvent(File(picked.path)),
      );
    }
  }

  void _onSubmit(BuildContext context, EditVehicleState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = UpdateVehicleParams(
      vehicleTypeId: state.selectedVehicleType?.id,
      plateNumber: _plateNumberController.text.trim(),
      licenseDocument: state.licenseFile,
    );

    context.read<EditVehicleCubit>().doEvent(SubmitVehicleInfoEvent(params));
  }

  void _handleListener(BuildContext context, EditVehicleState state) {
    if (state.updateVehicleState.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.updateVehicleState.data!),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else if (state.updateVehicleState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.updateVehicleState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String? _validateRequired(String? val, AppLocalizations l10n) {
    if (val == null || val.trim().isEmpty) return l10n.emptyValidationError;
    return null;
  }
}
