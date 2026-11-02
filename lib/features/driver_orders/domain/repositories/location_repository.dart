import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Stream<LocationEntity> getDriverLocationStream();
  Future<LocationEntity?> getCurrentLocation();
}
