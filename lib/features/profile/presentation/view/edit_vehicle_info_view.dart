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

class _EditVehicleInfoViewState extends State<EditVehicleInfoView>
    with BaseViewMixin<EditVehicleInfoView, EditVehicleCubit, BaseEvent> {
  late final EditVehicleCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _plateNumberController = TextEditingController();

  @override
  EditVehicleCubit get cubit => _cubit;

  @override
  void initState() {
    _cubit = getIt<EditVehicleCubit>()..doEvent(const LoadVehicleTypesEvent());
    super.initState();
  }

  @override
  void showSuccessSnackBar(String message) {
    super.showSuccessSnackBar(message);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<EditVehicleCubit>(
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
                  BlocBuilder<EditVehicleCubit, EditVehicleState>(
                    buildWhen: (prev, curr) =>
                        prev.vehicleTypesState != curr.vehicleTypesState ||
                        prev.selectedVehicleType != curr.selectedVehicleType,
                    builder: (context, state) {
                      return VehicleTypeDropdownField(
                        vehicleTypes: state.vehicleTypesState.data ?? [],
                        selectedVehicleType: state.selectedVehicleType,
                        isLoading: state.vehicleTypesState.isLoading,
                        onChanged: (type) {
                          if (type != null) {
                            _cubit.doEvent(SelectVehicleTypeEvent(type));
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: l10n.vehicleNumberLabel,
                    hint: l10n.vehicleNumberHint,
                    controller: _plateNumberController,
                    localizations: l10n,
                    validator: (val) => FormValidator.validateRequired(
                      val,
                      l10n.emptyValidationError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EditVehicleCubit, EditVehicleState>(
                    buildWhen: (prev, curr) =>
                        prev.licenseFile != curr.licenseFile,
                    builder: (context, state) {
                      return FileUploadField(
                        label: l10n.vehicleLicenseLabel,
                        hint: l10n.vehicleLicenseHint,
                        file: state.licenseFile,
                        onTap: () =>
                            _cubit.doEvent(const PickLicenseDocumentEvent()),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<EditVehicleCubit, EditVehicleState>(
                    buildWhen: (prev, curr) =>
                        prev.updateVehicleState != curr.updateVehicleState,
                    builder: (context, state) {
                      return _buildSubmitButton(context, state, l10n);
                    },
                  ),
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
      title: Text(l10n.editVehicleInfoTitle, style: AppStyles.bold20Inter),
      centerTitle: false,
      titleSpacing: 0,
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
            : () => _onSubmit(state),
      ),
    );
  }

  void _onSubmit(EditVehicleState state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final params = UpdateVehicleParams(
      vehicleTypeId: state.selectedVehicleType?.id,
      plateNumber: _plateNumberController.text.trim(),
      licenseDocument: state.licenseFile,
    );

    _cubit.doEvent(SubmitVehicleInfoEvent(params));
  }
}
