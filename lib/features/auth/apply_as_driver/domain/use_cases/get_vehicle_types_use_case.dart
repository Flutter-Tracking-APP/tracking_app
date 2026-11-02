import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';

@injectable
class GetVehicleTypesUseCase {
  final ApplyDriverRepository _repository;

  GetVehicleTypesUseCase(this._repository);

  Future<ApiResults<List<VehicleTypeEntity>>> call() async {
    return await _repository.getVehicleTypes();
  }
}
