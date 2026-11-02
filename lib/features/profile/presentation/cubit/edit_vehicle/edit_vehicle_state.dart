import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';

class EditVehicleState extends Equatable {
  final BaseState<List<VehicleTypeEntity>> vehicleTypesState;
  final BaseState<String> updateVehicleState;
  final VehicleTypeEntity? selectedVehicleType;
  final File? licenseFile;

  const EditVehicleState({
    this.vehicleTypesState = const BaseState.initial(),
    this.updateVehicleState = const BaseState.initial(),
    this.selectedVehicleType,
    this.licenseFile,
  });

  EditVehicleState copyWith({
    BaseState<List<VehicleTypeEntity>>? vehicleTypesState,
    BaseState<String>? updateVehicleState,
    VehicleTypeEntity? selectedVehicleType,
    File? licenseFile,
  }) {
    return EditVehicleState(
      vehicleTypesState: vehicleTypesState ?? this.vehicleTypesState,
      updateVehicleState: updateVehicleState ?? this.updateVehicleState,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      licenseFile: licenseFile ?? this.licenseFile,
    );
  }

  @override
  List<Object?> get props => [
    vehicleTypesState,
    updateVehicleState,
    selectedVehicleType,
    licenseFile?.path,
  ];
}
