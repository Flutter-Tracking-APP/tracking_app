import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class GetVehicleInfoUseCase {
  final ProfileRepository _repository;

  GetVehicleInfoUseCase(this._repository);

  Future<ApiResults<VehicleInfoEntity>> call() {
    return _repository.getVehicleInfo();
  }
}
