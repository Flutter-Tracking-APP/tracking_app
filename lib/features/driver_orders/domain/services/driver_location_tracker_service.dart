import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/update_driver_location_use_case.dart';

@singleton
class DriverLocationTrackerService {
  final UpdateDriverLocationUseCase _updateDriverLocationUseCase;

  Timer? _timer;
  StreamSubscription<Position>? _positionSubscription;
  LatLng? _currentLocation;

  final StreamController<LatLng> _locationStreamController =
      StreamController<LatLng>.broadcast();

  Stream<LatLng> get locationStream => _locationStreamController.stream;
  LatLng? get currentLocation => _currentLocation;

  DriverLocationTrackerService(this._updateDriverLocationUseCase);

  Future<bool> requestPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('DriverLocationTrackerService: Location services disabled');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('DriverLocationTrackerService: Location permissions denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('DriverLocationTrackerService: Location permissions permanently denied');
        return false;
      }

      return true;
    } catch (e) {
      log('DriverLocationTrackerService: Error checking location permissions: $e');
      return false;
    }
  }

  Future<void> startTracking({Duration interval = const Duration(seconds: 10)}) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      log('DriverLocationTrackerService: Cannot start tracking without permission');
    }

    // Try to get initial location
    try {
      final initialPos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      _updateCurrentPos(initialPos);
    } catch (e) {
      log('DriverLocationTrackerService: Could not fetch initial position: $e');
    }

    // Listen to continuous position updates from GPS device
    _positionSubscription?.cancel();
    try {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen(
        _updateCurrentPos,
        onError: (err) {
          log('DriverLocationTrackerService position stream error: $err');
        },
      );
    } catch (e) {
      log('DriverLocationTrackerService: Could not subscribe to position stream: $e');
    }

    // Setup periodic timer to send POST request to backend location endpoint
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _sendLocationUpdate());
    _sendLocationUpdate();
  }

  void _updateCurrentPos(Position pos) {
    _currentLocation = LatLng(pos.latitude, pos.longitude);
    _locationStreamController.add(_currentLocation!);
  }

  Future<void> _sendLocationUpdate() async {
    if (_currentLocation == null) {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 3),
          ),
        );
        _updateCurrentPos(pos);
      } catch (_) {}
    }

    if (_currentLocation == null) return;

    final result = await _updateDriverLocationUseCase(
      lat: _currentLocation!.latitude,
      lng: _currentLocation!.longitude,
      recordedAt: DateTime.now(),
    );

    if (result is Success) {
      log('DriverLocationTrackerService: Successfully sent location (${_currentLocation!.latitude}, ${_currentLocation!.longitude})');
    } else if (result is Failure) {
      log('DriverLocationTrackerService: Failed to send location: ${result.message}');
    }
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }
}
