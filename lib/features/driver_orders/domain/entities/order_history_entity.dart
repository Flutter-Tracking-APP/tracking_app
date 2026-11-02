import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';

class OrderHistoryEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String status;
  final String statusDisplay;
  final String? placedAt;
  final String? assignedAt;
  final int itemCount;
  final num total;
  final bool isGift;
  final StoreAddressEntity store;
  final UserAddressEntity user;

  const OrderHistoryEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusDisplay,
    this.placedAt,
    this.assignedAt,
    required this.itemCount,
    required this.total,
    this.isGift = false,
    required this.store,
    required this.user,
  });

  bool get isCompleted =>
      status.toUpperCase() == 'DELIVERED' ||
      statusDisplay.toUpperCase() == 'DELIVERED';

  bool get isCancelled =>
      status.toUpperCase().contains('CANCEL') ||
      statusDisplay.toUpperCase().contains('CANCEL');

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    statusDisplay,
    placedAt,
    assignedAt,
    itemCount,
    total,
    isGift,
    store,
    user,
  ];
}
