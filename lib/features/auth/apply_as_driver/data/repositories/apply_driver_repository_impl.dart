import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/safe_call.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/data_sources/contract/apply_driver_remote_data_source.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/mapper/apply_driver_mapper.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/mapper/vehicle_type_mapper.dart';
import 'package:tracking_app/features/auth/apply_as_driver/data/models/request/apply_driver_request_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';

@Injectable(as: ApplyDriverRepository)
class ApplyDriverRepositoryImpl implements ApplyDriverRepository {
  final ApplyDriverRemoteDataSource _remoteDataSource;

  ApplyDriverRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResults<DriverApplicationEntity>> applyAsDriver(
    ApplyDriverParams params,
  ) {
    return safeCall(() async {
      final dto = ApplyDriverRequestDto.fromDomain(params);
      final response = await _remoteDataSource.applyAsDriver(dto);
      return Success(response.toEntity());
    });
  }

  @override
  Future<ApiResults<List<VehicleTypeEntity>>> getVehicleTypes() {
    return safeCall(() async {
      final response = await _remoteDataSource.getVehicleTypes();
      final entities = response.data?.map((e) => e.toEntity()).toList() ?? [];
      return Success(entities);
    });
  }
}
