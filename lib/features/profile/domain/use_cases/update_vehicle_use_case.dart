import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/params/update_vehicle_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class UpdateVehicleUseCase {
  final ProfileRepository _repository;

  UpdateVehicleUseCase(this._repository);

  Future<ApiResults<String>> call(UpdateVehicleParams params) {
    return _repository.updateVehicle(params);
  }
}
