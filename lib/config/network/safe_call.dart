import 'package:dio/dio.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';

Future<ApiResults<T>> safeCall<T>(Future<ApiResults<T>> Function() call) async {
  try {
    return await call();
  } catch (e) {
    final error = errorParser(e as Exception);
    String? message;
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        message = (responseData['message'] ??
                responseData['error'] ??
                responseData['msg'])
            ?.toString();
        if ((message == null || message.trim().isEmpty) &&
            responseData['errors'] is List &&
            (responseData['errors'] as List).isNotEmpty) {
          final firstError = (responseData['errors'] as List).first;
          if (firstError is Map<String, dynamic>) {
            message = firstError['message']?.toString();
          } else {
            message = firstError?.toString();
          }
        }
      } else if (responseData is String) {
        message = responseData;
      }
    }
    return Failure(message, error);
  }
}

AppError errorParser(Exception exception) {
  if (exception is DioException) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError.timeout;

      case DioExceptionType.badCertificate:
        return AppError.security;

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.connectionError:
        return AppError.noConnection;

      case DioExceptionType.cancel:
        return AppError.cancelled;

      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return AppError.unknown;
    }
  }

  return AppError.unknown;
}

AppError _handleBadResponse(DioException exception) {
  final statusCode = exception.response?.statusCode;

  switch (statusCode) {
    case 400:
      return AppError.badRequest;

    case 401:
      return AppError.unauthorized;

    case 403:
      return AppError.forbidden;

    case 404:
      return AppError.notFound;

    case 409:
      return AppError.conflict;

    case 422:
      return AppError.validation;

    case 429:
      return AppError.tooManyRequests;

    case 500:
    case 502:
    case 503:
    case 504:
      return AppError.server;

    default:
      return AppError.unknown;
  }
}
