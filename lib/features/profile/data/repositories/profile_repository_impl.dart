import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/safe_call.dart';
import 'package:tracking_app/features/profile/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:tracking_app/features/profile/data/mapper/profile_mapper.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResults<UserProfileEntity>> getProfile() {
    return safeCall(() async {
      final response = await _remoteDataSource.getProfile();
      return Success(response.toEntity());
    });
  }

  @override
  Future<ApiResults<String>> updateProfile(UpdateProfileParams params) {
    return safeCall(() async {
      final parts = await params.toPartMap();
      final response = await _remoteDataSource.updateProfile(parts);
      return Success(response.message ?? 'Profile updated successfully');
    });
  }

  @override
  Future<ApiResults<VehicleInfoEntity>> getVehicleInfo() {
    return safeCall(() async {
      final response = await _remoteDataSource.getVehicleInfo();
      return Success(response.toEntity());
    });
  }

  @override
  Future<ApiResults<String>> updateVehicle(UpdateVehicleParams params) {
    return safeCall(() async {
      final formData = await params.toFormData();
      final response = await _remoteDataSource.updateVehicle(formData);
      return Success(response.message ?? 'Vehicle info updated successfully');
    });
  }

  @override
  Future<ApiResults<String>> changePassword(ChangePasswordParams params) {
    return safeCall(() async {
      final response = await _remoteDataSource.changePassword(params.toDto());
      return Success(response.message ?? 'Password changed successfully');
    });
  }
}
