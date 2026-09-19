import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/use_cases/get_vehicle_types_use_case.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_vehicle/edit_vehicle_state.dart';

@injectable
class EditVehicleCubit extends Cubit<EditVehicleState> {
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final UpdateVehicleUseCase _updateVehicleUseCase;

  EditVehicleCubit(this._getVehicleTypesUseCase, this._updateVehicleUseCase)
    : super(const EditVehicleState());

  void doEvent(EditVehicleEvents event) {
    switch (event) {
      case LoadVehicleTypesEvent():
        _loadVehicleTypes();
      case SelectVehicleTypeEvent(vehicleType: final vehicleType):
        emit(state.copyWith(selectedVehicleType: vehicleType));
      case PickLicenseDocumentEvent(file: final file):
        emit(state.copyWith(licenseFile: file));
      case SubmitVehicleInfoEvent(params: final params):
        _submitVehicleInfo(params);
    }
  }

  Future<void> _loadVehicleTypes() async {
    emit(state.copyWith(vehicleTypesState: BaseState.loading()));
    final result = await _getVehicleTypesUseCase.call();
    switch (result) {
      case Success(data: final types):
        emit(
          state.copyWith(
            vehicleTypesState: BaseState.success(types),
            selectedVehicleType: types.isNotEmpty ? types.first : null,
          ),
        );
      case Failure(error: final error, message: final msg):
        emit(
          state.copyWith(vehicleTypesState: BaseState.error(msg ?? error.name)),
        );
    }
  }

  Future<void> _submitVehicleInfo(UpdateVehicleParams params) async {
    emit(state.copyWith(updateVehicleState: BaseState.loading()));
    final result = await _updateVehicleUseCase.call(params);
    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(updateVehicleState: BaseState.success(message)));
      case Failure(error: final error, message: final msg):
        emit(
          state.copyWith(
            updateVehicleState: BaseState.error(msg ?? error.name),
          ),
        );
    }
  }
}
