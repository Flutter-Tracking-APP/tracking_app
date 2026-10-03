import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/config/app_config/app_config.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/services/driver_location_tracker_service.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_state.dart';
import 'package:tracking_app/features/tracking_order/domain/use_cases/get_route_use_case.dart';

@injectable
class DriverNavigationViewModel
    extends BaseCubit<DriverNavigationState, BaseEvent> {
  final GetDriverOrderDetailsUseCase _getOrderDetailsUseCase;
  final DriverLocationTrackerService _locationTrackerService;
  final GetRouteUseCase _getRouteUseCase;
  final AppConfig _appConfig;

  String get mapTilerApiKey => _appConfig.mapTilerApiKey;

  StreamSubscription<LatLng>? _locationSubscription;

  DriverNavigationViewModel(
    this._getOrderDetailsUseCase,
    this._locationTrackerService,
    this._getRouteUseCase,
    this._appConfig,
  ) : super(
          DriverNavigationState(
            driverLocation: const LatLng(30.0444, 31.2357),
            destinationLocation: const LatLng(30.0500, 31.2400),
          ),
        );

  void doEvent(DriverNavigationEvent event) {
    switch (event) {
      case InitNavigationEvent():
        _initNavigation(event);
      case DriverLocationUpdatedEvent():
        _onDriverLocationUpdated(event.newLocation);
    }
  }

  Future<void> _initNavigation(InitNavigationEvent event) async {
    emit(state.copyWith(isLoading: true, isPickup: event.isPickup));

    // Start live location tracking
    await _locationTrackerService.startTracking();

    final currentDriverPos = _locationTrackerService.currentLocation ??
        const LatLng(30.0444, 31.2357);

    // Subscribe to location updates
    _locationSubscription?.cancel();
    _locationSubscription = _locationTrackerService.locationStream.listen(
      (newDriverPos) {
        doEvent(DriverLocationUpdatedEvent(newDriverPos));
      },
    );

    if (event.initialOrder != null) {
      await _applyOrderData(
        event.initialOrder!,
        event.isPickup,
        currentDriverPos,
      );
    } else {
      final result = await _getOrderDetailsUseCase(event.orderId);
      if (result is Success<OrderDetailsEntity>) {
        await _applyOrderData(result.data, event.isPickup, currentDriverPos);
      } else if (result is Failure<OrderDetailsEntity>) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message ?? 'Failed to load order details',
          ),
        );
      }
    }
  }

  Future<void> _applyOrderData(
    OrderDetailsEntity order,
    bool isPickup,
    LatLng currentDriverPos,
  ) async {
    final destLat = isPickup ? order.store.lat : order.user.lat;
    final destLng = isPickup ? order.store.lng : order.user.lng;
    final destinationPos = LatLng(destLat, destLng);

    emit(
      state.copyWith(
        order: order,
        isPickup: isPickup,
        driverLocation: currentDriverPos,
        destinationLocation: destinationPos,
        isLoading: false,
      ),
    );

    await _updateRoute(currentDriverPos, destinationPos);
  }

  Future<void> _onDriverLocationUpdated(LatLng newPos) async {
    emit(state.copyWith(driverLocation: newPos));
    await _updateRoute(newPos, state.destinationLocation);
  }

  Future<void> _updateRoute(LatLng start, LatLng destination) async {
    try {
      final routeEntity = await _getRouteUseCase(
        start: start,
        end: destination,
      );

      if (routeEntity.points.isNotEmpty) {
        emit(state.copyWith(routePoints: routeEntity.points));
      } else {
        emit(
          state.copyWith(
            routePoints: _generateStreetGridRoute(start, destination),
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          routePoints: _generateStreetGridRoute(start, destination),
        ),
      );
    }
  }

  /// Generates a dummy route with intermediate turn between start and end as fallback.
  List<LatLng> _generateStreetGridRoute(LatLng start, LatLng end) {
    final double midLat = start.latitude + (end.latitude - start.latitude) * 0.6;
    final double midLng = start.longitude + (end.longitude - start.longitude) * 0.4;

    return [
      start,
      LatLng(start.latitude, midLng),
      LatLng(midLat, midLng),
      LatLng(midLat, end.longitude),
      end,
    ];
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _locationTrackerService.stopTracking();
    return super.close();
  }
}
