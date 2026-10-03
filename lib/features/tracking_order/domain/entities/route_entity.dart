import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class RouteEntity extends Equatable {
  final String code;
  final List<LatLng> points;

  const RouteEntity({
    required this.code,
    required this.points,
  });

  @override
  List<Object?> get props => [code, points];
}
