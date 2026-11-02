import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/tracking_order/domain/entities/route_entity.dart';

class RoutingResponseModel {
  final String code;
  final List<LocationEntity> points;

  const RoutingResponseModel({required this.code, required this.points});

  RouteEntity toEntity() {
    return RouteEntity(code: code, points: points);
  }

  factory RoutingResponseModel.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? 'Unknown';

    final routes = json['routes'] as List<dynamic>?;

    if (routes == null || routes.isEmpty) {
      return RoutingResponseModel(code: code, points: const []);
    }

    final firstRoute = routes.first as Map<String, dynamic>;

    final geometry = firstRoute['geometry'] as Map<String, dynamic>?;

    if (geometry == null) {
      return RoutingResponseModel(code: code, points: const []);
    }

    final coordinates = geometry['coordinates'] as List<dynamic>?;

    if (coordinates == null || coordinates.isEmpty) {
      return RoutingResponseModel(code: code, points: const []);
    }

    final points = coordinates.map((coordinate) {
      final pair = coordinate as List<dynamic>;

      final longitude = (pair[0] as num).toDouble();
      final latitude = (pair[1] as num).toDouble();

      return LocationEntity(latitude: latitude, longitude: longitude);
    }).toList();

    return RoutingResponseModel(code: code, points: points);
  }
}
