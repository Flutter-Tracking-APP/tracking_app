import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/const/endpoints.dart';
import 'package:tracking_app/features/profile/data/models/request/change_password_request_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/profile_action_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/user_profile_response_dto.dart';
import 'package:tracking_app/features/profile/data/models/response/vehicle_info_response_dto.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(Endpoints.getProfile)
  Future<UserProfileResponseDto> getProfile();

  @PUT(Endpoints.updateProfile)
  @MultiPart()
  Future<ProfileActionResponseDto> updateProfile(
    @Part() Map<String, dynamic> parts,
  );

  @GET(Endpoints.getVehicleInfo)
  Future<VehicleInfoResponseDto> getVehicleInfo();

  @PUT(Endpoints.updateVehicle)
  Future<ProfileActionResponseDto> updateVehicle(@Body() FormData formData);

  @POST(Endpoints.changePassword)
  Future<ProfileActionResponseDto> changePassword(
    @Body() ChangePasswordRequestDto request,
  );
}
