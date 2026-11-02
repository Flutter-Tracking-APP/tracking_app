import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/client/apply_driver_api_client.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/data_sources/contract/apply_driver_remote_data_source.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/request/apply_driver_request_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/apply_driver_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/vehicle_types_response_dto.dart';

@Injectable(as: ApplyDriverRemoteDataSource)
class ApplyDriverRemoteDataSourceImpl implements ApplyDriverRemoteDataSource {
  final ApplyDriverApiClient _apiClient;

  ApplyDriverRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ApplyDriverResponseDto> applyAsDriver(
    ApplyDriverRequestDto request,
  ) async {
    final parts = await request.toPartMap();
    return await _apiClient.applyAsDriver(parts);
  }

  @override
  Future<VehicleTypesResponseDto> getVehicleTypes() async {
    return await _apiClient.getVehicleTypes();
  }
}
