import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

class DriverNavigationState extends Equatable {
  final OrderDetailsEntity? order;
  final bool isPickup;
  final LatLng driverLocation;
  final LatLng destinationLocation;
  final List<LatLng> routePoints;
  final bool isLoading;
  final String? errorMessage;

  const DriverNavigationState({
    this.order,
    this.isPickup = true,
    required this.driverLocation,
    required this.destinationLocation,
    this.routePoints = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  DriverNavigationState copyWith({
    OrderDetailsEntity? order,
    bool? isPickup,
    LatLng? driverLocation,
    LatLng? destinationLocation,
    List<LatLng>? routePoints,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DriverNavigationState(
      order: order ?? this.order,
      isPickup: isPickup ?? this.isPickup,
      driverLocation: driverLocation ?? this.driverLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      routePoints: routePoints ?? this.routePoints,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        order,
        isPickup,
        driverLocation,
        destinationLocation,
        routePoints,
        isLoading,
        errorMessage,
      ];
}
