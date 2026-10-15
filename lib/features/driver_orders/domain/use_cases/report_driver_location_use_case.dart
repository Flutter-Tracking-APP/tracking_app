import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/location_repository.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_driver_location_use_case.dart';

@injectable
class ReportDriverLocationUseCase {
  final LocationRepository _locationRepository;
  final UpdateDriverLocationUseCase _updateDriverLocationUseCase;

  StreamSubscription<LocationEntity>? _locationSubscription;
  DateTime? _lastReportedTime;

  ReportDriverLocationUseCase(
    this._locationRepository,
    this._updateDriverLocationUseCase,
  );

  /// Starts listening to driver location and reporting to the backend.
  /// A throttle interval is applied to avoid flooding the backend.
  void startReporting({
    Duration throttleInterval = const Duration(seconds: 10),
  }) {
    _locationSubscription?.cancel();

    // report initial location immediately
    _locationRepository.getCurrentLocation().then((initialPos) {
      if (initialPos != null) {
        _reportLocation(initialPos);
      }
    });

    _locationSubscription = _locationRepository
        .getDriverLocationStream()
        .listen((location) {
          final now = DateTime.now();
          if (_lastReportedTime == null ||
              now.difference(_lastReportedTime!) >= throttleInterval) {
            _reportLocation(location);
            _lastReportedTime = now;
          }
        });
  }

  void stopReporting() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _lastReportedTime = null;
  }

  Future<void> _reportLocation(LocationEntity location) async {
    await _updateDriverLocationUseCase(
      lat: location.latitude,
      lng: location.longitude,
      recordedAt: location.timestamp ?? DateTime.now(),
    );
  }
}
