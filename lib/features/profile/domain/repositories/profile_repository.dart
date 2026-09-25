import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';

abstract interface class ProfileRepository {
  Future<ApiResults<UserProfileEntity>> getProfile();
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params);
  Future<ApiResults<VehicleInfoEntity>> getVehicleInfo();
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params);
  Future<ApiResults<String>> changePassword(ChangePasswordParams params);
}
