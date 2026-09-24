import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/image_picker_service.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/apply_as_driver_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_events.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_state.dart';

@injectable
class ApplyDriverCubit extends BaseCubit<ApplyDriverState, BaseEvent> {
  final ApplyAsDriverUseCase _applyAsDriverUseCase;
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final ImagePickerService _imagePickerService;

  ApplyDriverCubit(
    this._applyAsDriverUseCase,
    this._getVehicleTypesUseCase,
    this._imagePickerService,
  ) : super(const ApplyDriverState());

  void doEvent(ApplyDriverEvents event) {
    switch (event) {
      case GetVehicleTypesEvent():
        _getVehicleTypes();
      case SubmitApplyDriverEvent(params: final params):
        _submitApplication(params);
      case SelectGenderEvent(gender: final gender):
        emit(state.copyWith(selectedGender: gender));
      case SelectVehicleTypeEvent(vehicleType: final vehicleType):
        emit(state.copyWith(selectedVehicleType: vehicleType));
      case PickLicenceImageEvent(file: final file):
        _pickLicenceImage(file);
      case PickNidImageEvent(file: final file):
        _pickNidImage(file);
      case TogglePasswordVisibilityEvent():
        emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
      case ToggleConfirmPasswordVisibilityEvent():
        emit(
          state.copyWith(
            isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
          ),
        );
    }
  }

  Future<void> _pickLicenceImage(File? file) async {
    if (file != null) {
      emit(state.copyWith(licenceImage: file));
      return;
    }
    final picked = await _imagePickerService.pickImageFromGallery();
    if (picked != null) {
      emit(state.copyWith(licenceImage: picked));
    }
  }

  Future<void> _pickNidImage(File? file) async {
    if (file != null) {
      emit(state.copyWith(nidImage: file));
      return;
    }
    final picked = await _imagePickerService.pickImageFromGallery();
    if (picked != null) {
      emit(state.copyWith(nidImage: picked));
    }
  }

  Future<void> _getVehicleTypes() async {
    emit(state.copyWith(vehicleTypesState: BaseState.loading()));
    final result = await _getVehicleTypesUseCase.call();
    switch (result) {
      case Success(data: final data):
        emit(
          state.copyWith(
            vehicleTypesState: BaseState.success(data),
            selectedVehicleType: data.isNotEmpty ? data.first : null,
          ),
        );
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(
          state.copyWith(vehicleTypesState: BaseState.error(errorMsg)),
        );
    }
  }

  Future<void> _submitApplication(ApplyDriverParams params) async {
    emit(state.copyWith(applyState: BaseState.loading()));
    final result = await _applyAsDriverUseCase.call(params);
    switch (result) {
      case Success(data: final data):
        emit(state.copyWith(applyState: BaseState.success(data)));
        emitEvent(const NavigateEvent(AppRoutes.applyDriverSuccess));
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(state.copyWith(applyState: BaseState.error(errorMsg)));
        emitEvent(DisplayError(errorMsg));
    }
  }
}
