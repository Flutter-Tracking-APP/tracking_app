import 'dart:io';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';

sealed class ApplyDriverEvents {
  const ApplyDriverEvents();
}

final class GetVehicleTypesEvent extends ApplyDriverEvents {
  const GetVehicleTypesEvent();
}

final class SubmitApplyDriverEvent extends ApplyDriverEvents {
  final ApplyDriverParams params;

  const SubmitApplyDriverEvent(this.params);
}

final class SelectGenderEvent extends ApplyDriverEvents {
  final int gender;

  const SelectGenderEvent(this.gender);
}

final class SelectVehicleTypeEvent extends ApplyDriverEvents {
  final VehicleTypeEntity vehicleType;

  const SelectVehicleTypeEvent(this.vehicleType);
}

final class PickLicenceImageEvent extends ApplyDriverEvents {
  final File? file;

  const PickLicenceImageEvent([this.file]);
}

final class PickNidImageEvent extends ApplyDriverEvents {
  final File? file;

  const PickNidImageEvent([this.file]);
}

final class TogglePasswordVisibilityEvent extends ApplyDriverEvents {
  const TogglePasswordVisibilityEvent();
}

final class ToggleConfirmPasswordVisibilityEvent extends ApplyDriverEvents {
  const ToggleConfirmPasswordVisibilityEvent();
}
