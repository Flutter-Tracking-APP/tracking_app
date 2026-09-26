import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';

part 'order_details_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderDetailsResponseDto {
  final bool? status;
  final String? message;
  final OrderDetailsDataDto? order;
  final OrderDetailsDataDto? data;

  const OrderDetailsResponseDto({
    this.status,
    this.message,
    this.order,
    this.data,
  });

  factory OrderDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final sanitized = Map<String, dynamic>.from(json);

    if (sanitized['data'] is List) {
      final list = sanitized['data'] as List;
      sanitized['data'] = list.isNotEmpty && list.first is Map<String, dynamic>
          ? list.first as Map<String, dynamic>
          : null;
    }

    if (sanitized['order'] is List) {
      final list = sanitized['order'] as List;
      sanitized['order'] = list.isNotEmpty && list.first is Map<String, dynamic>
          ? list.first as Map<String, dynamic>
          : null;
    }

    if (sanitized['orders'] is List &&
        sanitized['order'] == null &&
        sanitized['data'] == null) {
      final list = sanitized['orders'] as List;
      sanitized['order'] = list.isNotEmpty && list.first is Map<String, dynamic>
          ? list.first as Map<String, dynamic>
          : null;
    }

    if (sanitized['order'] == null &&
        sanitized['data'] == null &&
        (sanitized.containsKey('orderId') ||
            sanitized.containsKey('_id') ||
            sanitized.containsKey('id'))) {
      return OrderDetailsResponseDto(
        status: sanitized['status'] as bool?,
        message: sanitized['message'] as String?,
        order: OrderDetailsDataDto.fromJson(sanitized),
      );
    }

    return _$OrderDetailsResponseDtoFromJson(sanitized);
  }

  OrderDetailsDataDto? get effectiveData => order ?? data;
}

@JsonSerializable(createToJson: false)
class OrderDetailsDataDto {
  final String? orderId;
  @JsonKey(name: '_id')
  final String? mongoId;
  final String? id;
  final String? orderNumber;
  final String? status;
  final String? statusDisplay;
  final String? createdAt;
  final String? placedAt;
  final StoreAddressDto? store;
  final StoreAddressDto? pickup;
  final UserAddressDto? user;
  final List<OrderItemDto>? orderItems;
  final List<OrderItemDto>? items;
  final num? totalPrice;
  final num? total;
  final String? paymentMethod;
  final String? paymentMethodDisplay;
  final String? paymentType;

  const OrderDetailsDataDto({
    this.orderId,
    this.mongoId,
    this.id,
    this.orderNumber,
    this.status,
    this.statusDisplay,
    this.createdAt,
    this.placedAt,
    this.store,
    this.pickup,
    this.user,
    this.orderItems,
    this.items,
    this.totalPrice,
    this.total,
    this.paymentMethod,
    this.paymentMethodDisplay,
    this.paymentType,
  });

  factory OrderDetailsDataDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDataDtoFromJson(json);

  String get effectiveId => orderId ?? id ?? mongoId ?? '';
  String get effectiveOrderNumber =>
      orderNumber ?? (effectiveId.length > 6 ? effectiveId.substring(effectiveId.length - 6) : effectiveId);
  StoreAddressDto? get effectiveStore => pickup ?? store;
  num get effectiveTotal => totalPrice ?? total ?? 0;
  List<OrderItemDto> get effectiveItems => orderItems ?? items ?? [];
  String? get effectiveDate => placedAt ?? createdAt;
  String get effectivePaymentMethod {
    if (paymentMethodDisplay != null && paymentMethodDisplay!.isNotEmpty) {
      return paymentMethodDisplay!;
    }
    final raw = paymentMethod ?? paymentType;
    if (raw == null || raw.isEmpty) return 'Cash on delivery';
    final lower = raw.toLowerCase();
    if (lower == 'cod' || lower.contains('cash')) {
      return 'Cash on delivery';
    }
    return raw;
  }
}

@JsonSerializable(createToJson: false)
class OrderItemDto {
  @JsonKey(name: '_id')
  final String? mongoId;
  final String? id;
  final String? title;
  final String? name;
  final String? productName;
  final num? price;
  final num? unitPrice;
  final int? quantity;
  final String? image;
  final String? imageUrl;
  final String? productImageUrl;

  const OrderItemDto({
    this.mongoId,
    this.id,
    this.title,
    this.name,
    this.productName,
    this.price,
    this.unitPrice,
    this.quantity,
    this.image,
    this.imageUrl,
    this.productImageUrl,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  String get effectiveId => id ?? mongoId ?? '';
  String get effectiveTitle => productName ?? name ?? title ?? 'Flower';
  num get effectivePrice => unitPrice ?? price ?? 0;
  int get effectiveQuantity => quantity ?? 1;
  String? get effectiveImage => productImageUrl ?? imageUrl ?? image;
}
