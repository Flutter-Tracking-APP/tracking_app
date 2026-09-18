import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/apply_as_driver_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_events.dart';
import 'package:tracking_app/features/auth/apply_as_driver/presentation/cubit/apply_driver_state.dart';

@injectable
class ApplyDriverCubit extends Cubit<ApplyDriverState> {
  final ApplyAsDriverUseCase _applyAsDriverUseCase;
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;

  ApplyDriverCubit(this._applyAsDriverUseCase, this._getVehicleTypesUseCase)
    : super(const ApplyDriverState());

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
        emit(state.copyWith(licenceImage: file));
      case PickNidImageEvent(file: final file):
        emit(state.copyWith(nidImage: file));
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
        emit(
          state.copyWith(vehicleTypesState: BaseState.error(msg ?? error.name)),
        );
    }
  }

  Future<void> _submitApplication(ApplyDriverParams params) async {
    emit(state.copyWith(applyState: BaseState.loading()));
    final result = await _applyAsDriverUseCase.call(params);
    switch (result) {
      case Success(data: final data):
        emit(state.copyWith(applyState: BaseState.success(data)));
      case Failure(error: final error, message: final msg):
        emit(state.copyWith(applyState: BaseState.error(msg ?? error.name)));
    }
  }
}
