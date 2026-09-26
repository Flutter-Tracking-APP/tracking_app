import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/driver_orders/data/mapper/order_mapper.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/available_orders_response_dto.dart';
import 'package:tracking_app/features/driver_orders/data/models/response/order_details_response_dto.dart';

void main() {
  group('OrderDtoMapper', () {
    test('maps orderId correctly into OrderEntity.id', () {
      const orderDto = OrderDto(
        orderId: 'a0000000-0000-0000-0000-000000000001',
        title: 'Test Order',
        totalAmount: 70.0,
      );

      final entity = orderDto.toEntity();

      expect(entity.id, equals('a0000000-0000-0000-0000-000000000001'));
      expect(entity.totalAmount, equals(70.0));
      expect(entity.title, equals('Test Order'));
    });

    test('falls back to id or mongoId if orderId is null', () {
      const orderDtoWithId = OrderDto(
        id: 'fallback-id-123',
      );
      expect(orderDtoWithId.toEntity().id, equals('fallback-id-123'));

      const orderDtoWithMongoId = OrderDto(
        mongoId: 'mongo-id-456',
      );
      expect(orderDtoWithMongoId.toEntity().id, equals('mongo-id-456'));
    });
  });

  group('OrderDetailsDataDtoMapper', () {
    test('maps orderId correctly into OrderDetailsEntity.id', () {
      const detailsDto = OrderDetailsDataDto(
        orderId: 'a0000000-0000-0000-0000-000000000002',
        orderNumber: 'ORD-999',
        totalPrice: 150.0,
      );

      final entity = detailsDto.toEntity();

      expect(entity.id, equals('a0000000-0000-0000-0000-000000000002'));
      expect(entity.orderNumber, equals('ORD-999'));
      expect(entity.total, equals(150.0));
    });

    test('maps pickup address and user address correctly', () {
      const detailsDto = OrderDetailsDataDto(
        orderId: 'ord-details-1',
        pickup: StoreAddressDto(
          storeName: 'Flower Hub',
          addressLine: '123 Garden St',
          phoneNumber: '01012345678',
          whatsAppNumber: '01012345679',
        ),
        user: UserAddressDto(
          name: 'Jane Doe',
          addressLine: '456 Customer Ave',
          phone: '01298765432',
        ),
        items: [
          OrderItemDto(
            productName: 'Red Roses Bouquet',
            unitPrice: 250.0,
            productImageUrl: 'https://example.com/roses.png',
            quantity: 2,
          ),
        ],
        totalPrice: 500.0,
      );

      final entity = detailsDto.toEntity();

      expect(entity.store.name, equals('Flower Hub'));
      expect(entity.store.address, equals('123 Garden St'));
      expect(entity.store.phone, equals('01012345678'));
      expect(entity.store.whatsAppNumber, equals('01012345679'));

      expect(entity.user.name, equals('Jane Doe'));
      expect(entity.user.address, equals('456 Customer Ave'));
      expect(entity.user.phone, equals('01298765432'));

      expect(entity.items.length, equals(1));
      expect(entity.items.first.title, equals('Red Roses Bouquet'));
      expect(entity.items.first.name, equals('Red Roses Bouquet'));
      expect(entity.items.first.price, equals(250.0));
      expect(entity.items.first.imageUrl, equals('https://example.com/roses.png'));
      expect(entity.items.first.quantity, equals(2));
    });

    test('maps placedAt into formattedDate and maps paymentMethodDisplay', () {
      const detailsDto = OrderDetailsDataDto(
        orderId: 'ord-placed-1',
        placedAt: '2026-09-05T17:45:13.6917287Z',
        paymentMethodDisplay: 'Cash on delivery',
      );

      final entity = detailsDto.toEntity();

      expect(entity.formattedDate, isNotNull);
      expect(entity.formattedDate, contains('2026'));
      expect(entity.paymentMethod, equals('Cash on delivery'));
      expect(entity.paymentMethodDisplay, equals('Cash on delivery'));
    });

    test('falls back to pre-formatted string if not valid ISO', () {
      const detailsDto = OrderDetailsDataDto(
        orderId: 'ord-placed-2',
        createdAt: 'Wed, 03 Sep 2024, 11:00 AM',
        paymentMethod: 'Cod',
      );

      final entity = detailsDto.toEntity();

      expect(entity.formattedDate, equals('Wed, 03 Sep 2024, 11:00 AM'));
      expect(entity.paymentMethod, equals('Cash on delivery'));
    });
  });

  group('StoreAddressDtoMapper', () {
    test('maps addressLine, phoneNumber, whatsAppNumber and storeName correctly', () {
      const dto = StoreAddressDto(
        storeName: 'Bouquet Paradise',
        addressLine: '77 Nile Corniche',
        phoneNumber: '01122334455',
        whatsAppNumber: '01122334466',
      );

      final entity = dto.toEntity();
      expect(entity.name, equals('Bouquet Paradise'));
      expect(entity.address, equals('77 Nile Corniche'));
      expect(entity.addressLine, equals('77 Nile Corniche'));
      expect(entity.phone, equals('01122334455'));
      expect(entity.phoneNumber, equals('01122334455'));
      expect(entity.whatsAppNumber, equals('01122334466'));
    });
  });

  group('UserAddressDtoMapper', () {
    test('maps addressLine and phone correctly', () {
      const dto = UserAddressDto(
        name: 'Ahmed Ali',
        addressLine: '10 Tahrir Square',
        phone: '01511223344',
      );

      final entity = dto.toEntity();
      expect(entity.name, equals('Ahmed Ali'));
      expect(entity.address, equals('10 Tahrir Square'));
      expect(entity.phone, equals('01511223344'));
    });
  });

  group('OrderItemDtoMapper', () {
    test('maps productName, unitPrice, productImageUrl correctly', () {
      const dto = OrderItemDto(
        productName: 'Sunflower Bouquet',
        unitPrice: 180.0,
        productImageUrl: 'https://example.com/sunflower.jpg',
        quantity: 3,
      );

      final entity = dto.toEntity();
      expect(entity.title, equals('Sunflower Bouquet'));
      expect(entity.name, equals('Sunflower Bouquet'));
      expect(entity.price, equals(180.0));
      expect(entity.imageUrl, equals('https://example.com/sunflower.jpg'));
      expect(entity.quantity, equals(3));
    });
  });

  group('OrderDetailsResponseDto', () {
    test('handles data when it is a List', () {
      final json = {
        'status': true,
        'message': 'success',
        'data': [
          {
            'orderId': 'ord-list-1',
            'orderNumber': 'ORD-LIST-1',
            'totalPrice': 200.0,
          }
        ],
      };

      final dto = OrderDetailsResponseDto.fromJson(json);
      expect(dto.effectiveData, isNotNull);
      expect(dto.effectiveData!.effectiveId, equals('ord-list-1'));
      expect(dto.effectiveData!.effectiveTotal, equals(200.0));
    });

    test('handles orders when it is a List', () {
      final json = {
        'status': true,
        'orders': [
          {
            'orderId': 'ord-orders-1',
            'orderNumber': 'ORD-ORDERS-1',
            'totalPrice': 350.0,
          }
        ],
      };

      final dto = OrderDetailsResponseDto.fromJson(json);
      expect(dto.effectiveData, isNotNull);
      expect(dto.effectiveData!.effectiveId, equals('ord-orders-1'));
    });

    test('handles root-level order json without wrapper', () {
      final json = {
        'orderId': 'ord-root-1',
        'orderNumber': 'ORD-ROOT-1',
        'totalPrice': 500.0,
      };

      final dto = OrderDetailsResponseDto.fromJson(json);
      expect(dto.effectiveData, isNotNull);
      expect(dto.effectiveData!.effectiveId, equals('ord-root-1'));
    });
  });
}
