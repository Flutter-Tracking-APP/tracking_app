import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/vehicle_types_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';

extension VehicleTypeDtoMapper on VehicleTypeDto {
  VehicleTypeEntity toEntity() {
    return VehicleTypeEntity(id: id ?? '', name: name ?? '');
  }
}
