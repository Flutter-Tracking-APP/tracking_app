import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/safe_call.dart';
import 'package:tracking_app/features/driver_orders/data/data_sources/contract/driver_orders_remote_data_source.dart';
import 'package:tracking_app/features/driver_orders/data/mapper/order_mapper.dart';
import 'package:tracking_app/features/driver_orders/data/models/request/update_order_status_request_dto.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_details_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:tracking_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';

@Injectable(as: DriverOrdersRepository)
class DriverOrdersRepositoryImpl implements DriverOrdersRepository {
  final DriverOrdersRemoteDataSource _remoteDataSource;

  DriverOrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResults<List<OrderEntity>>> getAvailableOrders() {
    return safeCall(() async {
      final response = await _remoteDataSource.getAvailableOrders();
      final list = response.orders ?? response.data ?? [];
      final entities = list.map((dto) => dto.toEntity()).toList();
      return Success(entities);
    });
  }

  @override
  Future<ApiResults<String>> claimOrder(String orderId) {
    return safeCall(() async {
      final response = await _remoteDataSource.claimOrder(orderId);
      return Success(response.message ?? 'Order claimed successfully');
    });
  }

  @override
  Future<ApiResults<OrderDetailsEntity>> getOrderDetails(String orderId) {
    return safeCall(() async {
      final response = await _remoteDataSource.getOrderDetails(orderId);
      final data = response.effectiveData;
      if (data == null) {
        throw Exception('Order details not found');
      }
      return Success(data.toEntity());
    });
  }

  @override
  Future<ApiResults<String>> updateOrderStatus(
    String orderId,
    String status,
  ) {
    return safeCall(() async {
      final response = await _remoteDataSource.updateOrderStatus(
        orderId,
        UpdateOrderStatusRequestDto(status: status),
      );
      return Success(response.message ?? 'Order status updated successfully');
    });
  }

  @override
  Future<ApiResults<OrderDetailsEntity?>> getActiveOrder() {
    return safeCall(() async {
      try {
        final response = await _remoteDataSource.getAssignedOrder();
        final data = response.effectiveData;
        if (data == null || data.effectiveId.isEmpty) {
          log('DriverOrdersRepositoryImpl.getActiveOrder: no assigned order');
          return const Success(null);
        }

        final entity = data.toEntity();
        if (entity.status == OrderFulfillmentStatus.delivered) {
          log('DriverOrdersRepositoryImpl.getActiveOrder: assigned order is delivered');
          return const Success(null);
        }

        log('DriverOrdersRepositoryImpl.getActiveOrder: assigned order found -> ${entity.id}');
        return Success(entity);
      } catch (e, stack) {
        if (e is DioException && (e.response?.statusCode == 404 || e.response?.statusCode == 204)) {
          log('DriverOrdersRepositoryImpl.getActiveOrder: 404/204 - no active assigned order');
          return const Success(null);
        }
        log('DriverOrdersRepositoryImpl.getActiveOrder error: $e', stackTrace: stack);
        return const Success(null);
      }
    });
  }
}
