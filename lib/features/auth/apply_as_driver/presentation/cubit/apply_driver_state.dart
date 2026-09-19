import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';

class ApplyDriverState extends Equatable {
  final BaseState<DriverApplicationEntity> applyState;
  final BaseState<List<VehicleTypeEntity>> vehicleTypesState;
  final int selectedGender;
  final VehicleTypeEntity? selectedVehicleType;
  final File? licenceImage;
  final File? nidImage;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const ApplyDriverState({
    this.applyState = const BaseState.initial(),
    this.vehicleTypesState = const BaseState.initial(),
    this.selectedGender = 0,
    this.selectedVehicleType,
    this.licenceImage,
    this.nidImage,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  ApplyDriverState copyWith({
    BaseState<DriverApplicationEntity>? applyState,
    BaseState<List<VehicleTypeEntity>>? vehicleTypesState,
    int? selectedGender,
    VehicleTypeEntity? selectedVehicleType,
    File? licenceImage,
    File? nidImage,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return ApplyDriverState(
      applyState: applyState ?? this.applyState,
      vehicleTypesState: vehicleTypesState ?? this.vehicleTypesState,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      licenceImage: licenceImage ?? this.licenceImage,
      nidImage: nidImage ?? this.nidImage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    applyState,
    vehicleTypesState,
    selectedGender,
    selectedVehicleType,
    licenceImage?.path,
    nidImage?.path,
    isPasswordVisible,
    isConfirmPasswordVisible,
  ];
}
