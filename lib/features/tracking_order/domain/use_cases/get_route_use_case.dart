import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/features/tracking_order/domain/entities/route_entity.dart';
import 'package:tracking_app/features/tracking_order/domain/repositories/routing_repository.dart';

@injectable
class GetRouteUseCase {
  final RoutingRepository _repository;

  GetRouteUseCase(this._repository);

  Future<RouteEntity> call({
    String? coordinates,
    LatLng? start,
    LatLng? end,
  }) {
    final actualCoordinates = coordinates ??
        (start != null && end != null
            ? '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
            : '');
    return _repository.getRoute(coordinates: actualCoordinates);
  }
}
