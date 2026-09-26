import 'package:json_annotation/json_annotation.dart';

part 'available_orders_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class AvailableOrdersResponseDto {
  final bool? status;
  final String? message;
  final List<OrderDto>? orders;
  final List<OrderDto>? data;

  const AvailableOrdersResponseDto({
    this.status,
    this.message,
    this.orders,
    this.data,
  });

  factory AvailableOrdersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrdersResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderDto {
  final String? orderId;
  @JsonKey(name: '_id')
  final String? mongoId;
  final String? id;
  final String? title;
  final String? orderTitle;
  final num? totalAmount;
  final num? totalPrice;
  final num? price;
  final String? status;
  final String? storeName;
  final String? storeAddress;
  final String? customerName;
  final String? customerAddress;
  final StoreAddressDto? store;
  final UserAddressDto? user;
  final String? createdAt;

  const OrderDto({
    this.orderId,
    this.mongoId,
    this.id,
    this.title,
    this.orderTitle,
    this.totalAmount,
    this.totalPrice,
    this.price,
    this.status,
    this.storeName,
    this.storeAddress,
    this.customerName,
    this.customerAddress,
    this.store,
    this.user,
    this.createdAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  String get effectiveId => orderId ?? id ?? mongoId ?? '';
  num get effectiveTotalAmount => totalAmount ?? totalPrice ?? price ?? 0;
  num get effectivePrice => effectiveTotalAmount;
  String get effectiveTitle =>
      (orderTitle != null && orderTitle!.isNotEmpty)
          ? orderTitle!
          : (title ?? 'Flower order');
  String get effectiveStoreName =>
      (storeName != null && storeName!.isNotEmpty)
          ? storeName!
          : (store?.name ?? 'Flowery store');
  String get effectiveStoreAddress =>
      (storeAddress != null && storeAddress!.isNotEmpty)
          ? storeAddress!
          : (store?.address ?? '');
  String get effectiveCustomerName =>
      (customerName != null && customerName!.isNotEmpty)
          ? customerName!
          : (user?.effectiveName ?? 'Customer');
  String get effectiveCustomerAddress =>
      (customerAddress != null && customerAddress!.isNotEmpty)
          ? customerAddress!
          : (user?.address ?? '');
}

@JsonSerializable(createToJson: false)
class StoreAddressDto {
  final String? name;
  final String? storeName;
  final String? address;
  final String? addressLine;
  final String? phone;
  final String? phoneNumber;
  final String? whatsAppNumber;
  final String? avatar;
  final String? image;

  const StoreAddressDto({
    this.name,
    this.storeName,
    this.address,
    this.addressLine,
    this.phone,
    this.phoneNumber,
    this.whatsAppNumber,
    this.avatar,
    this.image,
  });

  factory StoreAddressDto.fromJson(Map<String, dynamic> json) =>
      _$StoreAddressDtoFromJson(json);

  String get effectiveName => storeName ?? name ?? 'Flowery store';
  String get effectiveAddress => addressLine ?? address ?? '';
  String? get effectivePhone => phoneNumber ?? phone ?? whatsAppNumber;
  String? get effectiveWhatsApp => whatsAppNumber ?? phoneNumber ?? phone;
  String? get effectiveAvatar => avatar ?? image;
}

@JsonSerializable(createToJson: false)
class UserAddressDto {
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? addressLine;
  final String? phone;
  final String? phoneNumber;
  final String? avatar;
  final String? profilePictureUrl;

  const UserAddressDto({
    this.name,
    this.firstName,
    this.lastName,
    this.address,
    this.addressLine,
    this.phone,
    this.phoneNumber,
    this.avatar,
    this.profilePictureUrl,
  });

  factory UserAddressDto.fromJson(Map<String, dynamic> json) =>
      _$UserAddressDtoFromJson(json);

  String get effectiveName {
    if (name != null && name!.isNotEmpty) return name!;
    final combined = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return combined.isNotEmpty ? combined : 'Customer';
  }

  String get effectiveAddress => addressLine ?? address ?? '';
  String? get effectivePhone => phone ?? phoneNumber;
  String? get effectiveAvatar => avatar ?? profilePictureUrl;
}
