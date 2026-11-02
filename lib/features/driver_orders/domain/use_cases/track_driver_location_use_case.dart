import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/location_repository.dart';

@injectable
class TrackDriverLocationUseCase {
  final LocationRepository _repository;

  TrackDriverLocationUseCase(this._repository);

  Stream<LocationEntity> call() {
    return _repository.getDriverLocationStream();
  }
}
