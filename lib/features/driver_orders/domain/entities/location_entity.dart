import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  @override
  List<Object?> get props => [latitude, longitude, timestamp];
}
