import 'package:equatable/equatable.dart';

class VehicleInfoEntity extends Equatable {
  final String vehicleId;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String plateNumber;
  final int capacity;
  final String licenseDocument;

  const VehicleInfoEntity({
    required this.vehicleId,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.plateNumber,
    required this.capacity,
    required this.licenseDocument,
  });

  @override
  List<Object?> get props => [
    vehicleId,
    vehicleTypeId,
    vehicleTypeName,
    plateNumber,
    capacity,
    licenseDocument,
  ];
}
