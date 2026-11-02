import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';

class RouteEntity extends Equatable {
  final String code;
  final List<LocationEntity> points;

  const RouteEntity({required this.code, required this.points});

  @override
  List<Object?> get props => [code, points];
}
