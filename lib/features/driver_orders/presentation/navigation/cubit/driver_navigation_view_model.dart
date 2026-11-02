import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/app_config/app_config.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/location_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_driver_order_details_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/track_driver_location_use_case.dart';
import 'package:tracking_app/features/driver_orders/domain/use_cases/get_current_driver_location_use_case.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_events.dart';
import 'package:tracking_app/features/driver_orders/presentation/navigation/cubit/driver_navigation_state.dart';
import 'package:tracking_app/features/tracking_order/domain/use_cases/get_route_use_case.dart';

@injectable
class DriverNavigationViewModel
    extends BaseCubit<DriverNavigationState, BaseEvent> {
  final GetDriverOrderDetailsUseCase _getOrderDetailsUseCase;
  final TrackDriverLocationUseCase _trackDriverLocationUseCase;
  final GetCurrentDriverLocationUseCase _getCurrentDriverLocationUseCase;
  final GetRouteUseCase _getRouteUseCase;
  final AppConfig _appConfig;

  String get mapTilerApiKey => _appConfig.mapTilerApiKey;

  StreamSubscription? _locationSubscription;

  DriverNavigationViewModel(
    this._getOrderDetailsUseCase,
    this._trackDriverLocationUseCase,
    this._getCurrentDriverLocationUseCase,
    this._getRouteUseCase,
    this._appConfig,
  ) : super(
        DriverNavigationState(
          driverLocation: const LocationEntity(
            latitude: 30.0444,
            longitude: 31.2357,
          ),
          destinationLocation: const LocationEntity(
            latitude: 30.0500,
            longitude: 31.2400,
          ),
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

    final locationEntity = await _getCurrentDriverLocationUseCase();
    final currentDriverPos = locationEntity != null
        ? LocationEntity(
            latitude: locationEntity.latitude,
            longitude: locationEntity.longitude,
          )
        : const LocationEntity(latitude: 30.0444, longitude: 31.2357);

    // Subscribe to location updates
    _locationSubscription?.cancel();
    _locationSubscription = _trackDriverLocationUseCase().listen((newLocation) {
      doEvent(
        DriverLocationUpdatedEvent(
          LocationEntity(
            latitude: newLocation.latitude,
            longitude: newLocation.longitude,
          ),
        ),
      );
    });

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
    LocationEntity currentDriverPos,
  ) async {
    final destLat = isPickup ? order.store.lat : order.user.lat;
    final destLng = isPickup ? order.store.lng : order.user.lng;
    final destinationPos = LocationEntity(
      latitude: destLat,
      longitude: destLng,
    );

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

  Future<void> _onDriverLocationUpdated(LocationEntity newPos) async {
    emit(state.copyWith(driverLocation: newPos));
    await _updateRoute(newPos, state.destinationLocation);
  }

  Future<void> _updateRoute(
    LocationEntity start,
    LocationEntity destination,
  ) async {
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
  List<LocationEntity> _generateStreetGridRoute(
    LocationEntity start,
    LocationEntity end,
  ) {
    final double midLat =
        start.latitude + (end.latitude - start.latitude) * 0.6;
    final double midLng =
        start.longitude + (end.longitude - start.longitude) * 0.4;

    return [
      start,
      LocationEntity(latitude: start.latitude, longitude: midLng),
      LocationEntity(latitude: midLat, longitude: midLng),
      LocationEntity(latitude: midLat, longitude: end.longitude),
      end,
    ];
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
