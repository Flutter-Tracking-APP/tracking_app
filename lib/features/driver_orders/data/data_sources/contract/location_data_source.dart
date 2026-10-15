import 'package:tracking_app/features/driver_orders/data/models/location_model.dart';

abstract class LocationDataSource {
  Stream<LocationModel> getLocationStream();
  Future<LocationModel?> getCurrentLocation();
}
