import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';

class HistoricalOrderDetailsEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String status;
  final String statusDisplay;
  final String? assignmentStatus;
  final String? placedAt;
  final String? assignedAt;
  final num subtotal;
  final num deliveryFee;
  final num total;
  final String paymentMethod;
  final String paymentMethodDisplay;
  final String currency;
  final bool isGift;
  final StoreAddressEntity store;
  final UserAddressEntity user;
  final List<OrderItemEntity> items;

  const HistoricalOrderDetailsEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusDisplay,
    this.assignmentStatus,
    this.placedAt,
    this.assignedAt,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.paymentMethodDisplay,
    this.currency = 'EGP',
    this.isGift = false,
    required this.store,
    required this.user,
    required this.items,
  });

  bool get isCompleted =>
      status.toUpperCase() == 'DELIVERED' ||
      statusDisplay.toUpperCase() == 'DELIVERED';

  bool get isCancelled =>
      status.toUpperCase().contains('CANCEL') ||
      statusDisplay.toUpperCase().contains('CANCEL');

  OrderDetailsEntity toOrderDetailsEntity() {
    return OrderDetailsEntity(
      id: id,
      orderNumber: orderNumber,
      status: isCompleted
          ? OrderFulfillmentStatus.delivered
          : OrderFulfillmentStatus.accepted,
      rawStatus: status,
      formattedDate: placedAt,
      store: store,
      user: user,
      items: items,
      total: total,
      paymentMethod: paymentMethodDisplay.isNotEmpty
          ? paymentMethodDisplay
          : paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    statusDisplay,
    assignmentStatus,
    placedAt,
    assignedAt,
    subtotal,
    deliveryFee,
    total,
    paymentMethod,
    paymentMethodDisplay,
    currency,
    isGift,
    store,
    user,
    items,
  ];
}
