import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_item_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/store_address_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/user_address_entity.dart';

extension StoreAddressDtoMapper on StoreAddressDto? {
  StoreAddressEntity toEntity() {
    return StoreAddressEntity(
      name: (this?.effectiveName != null && this!.effectiveName.isNotEmpty)
          ? this!.effectiveName
          : 'Flowery store',
      address: this?.effectiveAddress ?? '',
      phone: this?.effectivePhone,
      whatsAppNumber: this?.effectiveWhatsApp,
      avatar: this?.effectiveAvatar,
    );
  }
}

extension UserAddressDtoMapper on UserAddressDto? {
  UserAddressEntity toEntity() {
    return UserAddressEntity(
      name: this?.effectiveName ?? 'Customer',
      address: this?.effectiveAddress ?? '',
      phone: this?.effectivePhone,
      avatar: this?.effectiveAvatar,
    );
  }
}

extension OrderItemDtoMapper on OrderItemDto {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: effectiveId,
      title: effectiveTitle,
      price: effectivePrice,
      quantity: effectiveQuantity,
      image: effectiveImage,
    );
  }
}

extension OrderDtoMapper on OrderDto {
  OrderEntity toEntity() {
    final sName = effectiveStoreName;
    final sAddress = effectiveStoreAddress;
    final cName = effectiveCustomerName;
    final cAddress = effectiveCustomerAddress;
    final amount = effectiveTotalAmount;

    return OrderEntity(
      id: effectiveId,
      title: effectiveTitle,
      totalAmount: amount,
      status: status ?? 'pending',
      storeName: sName,
      storeAddress: sAddress,
      customerName: cName,
      customerAddress: cAddress,
      store: StoreAddressEntity(
        name: sName,
        address: sAddress,
        phone: store?.effectivePhone,
        avatar: store?.effectiveAvatar,
        whatsAppNumber: store?.effectiveWhatsApp,
      ),
      user: UserAddressEntity(
        name: cName,
        address: cAddress,
        phone: user?.effectivePhone,
        avatar: user?.effectiveAvatar,
      ),
      createdAt: createdAt,
    );
  }
}

extension OrderDetailsDataDtoMapper on OrderDetailsDataDto {
  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      id: effectiveId,
      orderNumber: effectiveOrderNumber,
      status: _parseStatus(status),
      formattedDate: _formatDate(effectiveDate),
      store: effectiveStore.toEntity(),
      user: user.toEntity(),
      items: effectiveItems.map((e) => e.toEntity()).toList(),
      total: effectiveTotal,
      paymentMethod: effectivePaymentMethod,
    );
  }

  static String? _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    final dt = parsed.toLocal();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final weekday = weekdays[dt.weekday - 1];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour24 = dt.hour;
    final hour12 = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
    final hourStr = hour12.toString().padLeft(2, '0');
    final minuteStr = dt.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    return '$weekday, $day $month $year, $hourStr:$minuteStr $period';
  }

  static OrderFulfillmentStatus _parseStatus(String? rawStatus) {
    if (rawStatus == null) return OrderFulfillmentStatus.accepted;
    final normalized = rawStatus.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (normalized.contains('awaiting') ||
        normalized.contains('deliver') ||
        normalized == 'completed') {
      return OrderFulfillmentStatus.delivered;
    }
    if (normalized.contains('arrivedtouser') ||
        normalized == 'arrived' ||
        normalized.contains('reached')) {
      return OrderFulfillmentStatus.arrived;
    }
    if (normalized.contains('outfor') ||
        normalized.contains('start') ||
        normalized.contains('ondelivery') ||
        normalized.contains('ontheway')) {
      return OrderFulfillmentStatus.outForDelivery;
    }
    if (normalized.contains('pick')) {
      return OrderFulfillmentStatus.picked;
    }
    if (normalized.contains('prepare') ||
        normalized.contains('placed') ||
        normalized.contains('accept') ||
        normalized.contains('atpickup') ||
        normalized.contains('arrivedatpickup')) {
      return OrderFulfillmentStatus.accepted;
    }
    return OrderFulfillmentStatus.accepted;
  }
}
