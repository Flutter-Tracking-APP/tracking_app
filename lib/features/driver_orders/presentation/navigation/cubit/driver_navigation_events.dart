import 'package:latlong2/latlong.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';

sealed class DriverNavigationEvent {
  const DriverNavigationEvent();
}

class InitNavigationEvent extends DriverNavigationEvent {
  final String orderId;
  final bool isPickup;
  final OrderDetailsEntity? initialOrder;

  const InitNavigationEvent({
    required this.orderId,
    required this.isPickup,
    this.initialOrder,
  });
}

class DriverLocationUpdatedEvent extends DriverNavigationEvent {
  final LatLng newLocation;

  const DriverLocationUpdatedEvent(this.newLocation);
}
