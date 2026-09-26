import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';

enum OrderFulfillmentStatus {
  accepted,
  arrivedAtPickup,
  picked,
  outForDelivery,
  arrived,
  delivered,
}

class OrderDetailsEntity extends Equatable {
  final String id;
  final String orderNumber;
  final OrderFulfillmentStatus status;
  final String? formattedDate;
  final StoreAddressEntity store;
  final UserAddressEntity user;
  final List<OrderItemEntity> items;
  final num total;
  final String paymentMethod;

  const OrderDetailsEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.formattedDate,
    required this.store,
    required this.user,
    required this.items,
    required this.total,
    required this.paymentMethod,
  });

  String get paymentMethodDisplay => paymentMethod;

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    formattedDate,
    store,
    user,
    items,
    total,
    paymentMethod,
  ];
}
