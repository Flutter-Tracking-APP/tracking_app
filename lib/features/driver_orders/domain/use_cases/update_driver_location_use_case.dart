import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@injectable
class UpdateDriverLocationUseCase {
  final DriverOrdersRepository _repository;

  UpdateDriverLocationUseCase(this._repository);

  Future<ApiResults<void>> call({
    required double lat,
    required double lng,
    required DateTime recordedAt,
  }) {
    return _repository.updateDriverLocation(
      lat: lat,
      lng: lng,
      recordedAt: recordedAt,
    );
  }
}
