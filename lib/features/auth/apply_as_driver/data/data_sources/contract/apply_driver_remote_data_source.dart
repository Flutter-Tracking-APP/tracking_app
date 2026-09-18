import 'package:tracking_app/features/auth/apply_as_driver/data/models/request/apply_driver_request_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/apply_driver_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/vehicle_types_response_dto.dart';

abstract interface class ApplyDriverRemoteDataSource {
  Future<ApplyDriverResponseDto> applyAsDriver(ApplyDriverRequestDto request);

  Future<VehicleTypesResponseDto> getVehicleTypes();
}
