import 'dart:io';
import 'package:equatable/equatable.dart';

class UpdateVehicleParams extends Equatable {
  final String? vehicleTypeId;
  final String? plateNumber;
  final File? licenseDocument;

  const UpdateVehicleParams({
    this.vehicleTypeId,
    this.plateNumber,
    this.licenseDocument,
  });

  @override
  List<Object?> get props => [
    vehicleTypeId,
    plateNumber,
    licenseDocument?.path,
  ];
}
