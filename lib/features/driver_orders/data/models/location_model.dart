import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';

class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    );
  }
}
