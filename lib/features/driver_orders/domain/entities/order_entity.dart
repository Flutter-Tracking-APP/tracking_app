import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String title;
  final num totalAmount;
  final String status;
  final String storeName;
  final String storeAddress;
  final String customerName;
  final String customerAddress;
  final StoreAddressEntity store;
  final UserAddressEntity user;
  final String? createdAt;

  OrderEntity({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.status,
    required this.storeName,
    required this.storeAddress,
    required this.customerName,
    required this.customerAddress,
    StoreAddressEntity? store,
    UserAddressEntity? user,
    this.createdAt,
  }) : store =
           store ?? StoreAddressEntity(name: storeName, address: storeAddress),
       user =
           user ??
           UserAddressEntity(name: customerName, address: customerAddress);

  num get totalPrice => totalAmount;

  @override
  List<Object?> get props => [
    id,
    title,
    totalAmount,
    status,
    storeName,
    storeAddress,
    customerName,
    customerAddress,
    store,
    user,
    createdAt,
  ];
}
