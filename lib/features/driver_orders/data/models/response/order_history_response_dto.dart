import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';

part 'order_history_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class OrderHistoryResponseDto {
  final bool? status;
  final int? code;
  final String? message;
  final List<OrderHistoryItemDto>? data;
  final PaginationDto? pagination;

  const OrderHistoryResponseDto({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
  });

  factory OrderHistoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OrderHistoryItemDto {
  final String? id;
  @JsonKey(name: '_id')
  final String? mongoId;
  final String? orderId;
  final String? orderNumber;
  final String? status;
  final String? statusDisplay;
  final String? placedAt;
  final String? assignedAt;
  final String? createdAt;
  final int? itemCount;
  final num? total;
  final num? totalPrice;
  final bool? isGift;
  final DestinationDto? destination;
  final StoreAddressDto? pickup;
  final StoreAddressDto? store;
  final UserAddressDto? user;

  const OrderHistoryItemDto({
    this.id,
    this.mongoId,
    this.orderId,
    this.orderNumber,
    this.status,
    this.statusDisplay,
    this.placedAt,
    this.assignedAt,
    this.createdAt,
    this.itemCount,
    this.total,
    this.totalPrice,
    this.isGift,
    this.destination,
    this.pickup,
    this.store,
    this.user,
  });

  factory OrderHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryItemDtoFromJson(json);

  String get effectiveId => id ?? orderId ?? mongoId ?? '';
  String get effectiveOrderNumber =>
      orderNumber ??
      (effectiveId.length > 6
          ? effectiveId.substring(effectiveId.length - 6)
          : effectiveId);
  String get effectiveStatus => status ?? statusDisplay ?? 'DELIVERED';
  String get effectiveStatusDisplay => statusDisplay ?? status ?? 'Delivered';
  num get effectiveTotal => total ?? totalPrice ?? 0;
  String? get effectiveDate => placedAt ?? createdAt ?? assignedAt;
  StoreAddressDto? get effectiveStore => pickup ?? store;
}

@JsonSerializable(createToJson: false)
class DestinationDto {
  final String? recipientName;
  final String? recipientPhone;
  final String? addressLine;
  final String? city;
  final String? area;
  final num? lat;
  final num? lng;

  const DestinationDto({
    this.recipientName,
    this.recipientPhone,
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  factory DestinationDto.fromJson(Map<String, dynamic> json) =>
      _$DestinationDtoFromJson(json);

  String get effectiveAddress {
    final parts = [
      if (addressLine != null && addressLine!.isNotEmpty) addressLine!,
      if (area != null &&
          area!.isNotEmpty &&
          addressLine?.contains(area!) != true)
        area!,
      if (city != null &&
          city!.isNotEmpty &&
          addressLine?.contains(city!) != true)
        city!,
    ];
    return parts.join(', ');
  }
}

@JsonSerializable(createToJson: false)
class PaginationDto {
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const PaginationDto({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}
