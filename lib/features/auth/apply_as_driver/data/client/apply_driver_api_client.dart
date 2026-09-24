import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/config/network/network_constants.dart';
import 'package:tracking_app/core/const/endpoints.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/apply_driver_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/vehicle_types_response_dto.dart';

part 'apply_driver_api_client.g.dart';

@singleton
@RestApi()
abstract class ApplyDriverApiClient {
  @factoryMethod
  factory ApplyDriverApiClient(Dio dio) = _ApplyDriverApiClient;

  @POST(Endpoints.applyDriver)
  @MultiPart()
  Future<ApplyDriverResponseDto> applyAsDriver(
    @PartMap() Map<String, dynamic> parts,
  );

  @GET(Endpoints.vehicleTypes)
  @Extra({NetworkConstants.requiresToken: false})
  Future<VehicleTypesResponseDto> getVehicleTypes();
}
