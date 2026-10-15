import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/data/data_sources/contract/location_data_source.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/location_repository.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Stream<LocationEntity> getDriverLocationStream() {
    return _dataSource.getLocationStream().map((model) => model.toEntity());
  }

  @override
  Future<LocationEntity?> getCurrentLocation() async {
    final model = await _dataSource.getCurrentLocation();
    return model?.toEntity();
  }
}
