import 'dart:io';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';

sealed class EditVehicleEvents {
  const EditVehicleEvents();
}

final class LoadVehicleTypesEvent extends EditVehicleEvents {
  const LoadVehicleTypesEvent();
}

final class SelectVehicleTypeEvent extends EditVehicleEvents {
  final VehicleTypeEntity vehicleType;
  const SelectVehicleTypeEvent(this.vehicleType);
}

final class PickLicenseDocumentEvent extends EditVehicleEvents {
  final File file;
  const PickLicenseDocumentEvent(this.file);
}

final class SubmitVehicleInfoEvent extends EditVehicleEvents {
  final UpdateVehicleParams params;
  const SubmitVehicleInfoEvent(this.params);
}
