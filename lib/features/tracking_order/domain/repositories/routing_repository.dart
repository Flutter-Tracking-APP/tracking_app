import 'package:tracking_app/features/tracking_order/domain/entities/route_entity.dart';

abstract class RoutingRepository {
  Future<RouteEntity> getRoute({required String coordinates});
}
