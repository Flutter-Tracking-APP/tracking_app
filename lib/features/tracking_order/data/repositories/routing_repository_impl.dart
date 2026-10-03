import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/tracking_order/data/client/routing_api_client.dart';
import 'package:tracking_app/features/tracking_order/domain/entities/route_entity.dart';
import 'package:tracking_app/features/tracking_order/domain/repositories/routing_repository.dart';

@LazySingleton(as: RoutingRepository)
class RoutingRepositoryImpl implements RoutingRepository {
  final RoutingApiClient _apiClient;

  RoutingRepositoryImpl(this._apiClient);

  @override
  Future<RouteEntity> getRoute({required String coordinates}) async {
    final response = await _apiClient.getRoute(coordinates);
    return response.toEntity();
  }
}
