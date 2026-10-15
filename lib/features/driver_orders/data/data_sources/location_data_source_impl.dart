import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/driver_orders/data/data_sources/contract/location_data_source.dart';
import 'package:tracking_app/features/driver_orders/data/models/location_model.dart';

@LazySingleton(as: LocationDataSource)
class LocationDataSourceImpl implements LocationDataSource {
  StreamController<LocationModel>? _locationStreamController;
  StreamSubscription<Position>? _positionSubscription;

  LocationDataSourceImpl();

  Future<bool> _requestPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('LocationDataSource: Location services disabled');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('LocationDataSource: Location permissions denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('LocationDataSource: Location permissions permanently denied');
        return false;
      }

      return true;
    } catch (e) {
      log('LocationDataSource: Error checking location permissions: $e');
      return false;
    }
  }

  @override
  Stream<LocationModel> getLocationStream() {
    if (_locationStreamController != null &&
        !_locationStreamController!.isClosed) {
      return _locationStreamController!.stream;
    }

    _locationStreamController = StreamController<LocationModel>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );

    return _locationStreamController!.stream;
  }

  @override
  Future<LocationModel?> getCurrentLocation() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      return LocationModel.fromPosition(position);
    } catch (e) {
      log('LocationDataSource: Could not fetch current position: $e');
      return null;
    }
  }

  Future<void> _startListening() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      log('LocationDataSource: Cannot start tracking without permission');
      return;
    }

    try {
      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            ),
          ).listen(
            (Position position) {
              _locationStreamController?.add(
                LocationModel.fromPosition(position),
              );
            },
            onError: (err) {
              log('LocationDataSource position stream error: $err');
              _locationStreamController?.addError(err);
            },
          );
    } catch (e) {
      log('LocationDataSource: Could not subscribe to position stream: $e');
      _locationStreamController?.addError(e);
    }
  }

  void _stopListening() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }
}
