import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/location_repository.dart';

@injectable
class GetCurrentDriverLocationUseCase {
  final LocationRepository _repository;

  GetCurrentDriverLocationUseCase(this._repository);

  Future<LocationEntity?> call() {
    return _repository.getCurrentLocation();
  }
}
