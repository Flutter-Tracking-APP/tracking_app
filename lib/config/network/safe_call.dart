import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/const/app_strings.dart';

Future<ApiResults<T>> safeCall<T>(Future<ApiResults<T>> Function() call) async {
  try {
    final result = await call();
    return result;
  } catch (e) {
    var error = errorParser(e as Exception);
    return Failure(error.message, error);
  }
}

AppError errorParser(Exception exception) {
  if (exception is DioException) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutAppError(exception, AppStrings.connectionErrorMessage.toString());
      case DioExceptionType.badCertificate:
        return ForceLoginAppError(AppStrings.code401Message.toString());
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);
      case DioExceptionType.connectionError:
        return NoInternetAppError(AppStrings.noConnectionErrorMessage.toString());
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return IgnoreAppError();
    }
  }
  return IgnoreAppError();
}

AppError _handleBadResponse(DioException exception) {
  final response = exception.response;
  final statusCode = response?.statusCode;

  String? serverMessage;

  final data = response?.data;

  if (data is Map<String, dynamic>) {
    serverMessage = data["message"]?.toString();
  }

  switch (statusCode) {
    case 400:
      return BadRequestAppError(serverMessage ?? AppStrings.code400Message.toString());

    case 401:
      return ForceLoginAppError(serverMessage ?? AppStrings.code401Message.toString());

    case 403:
      return ForbiddenAppError(serverMessage ?? AppStrings.code403Message.toString());

    case 404:
      return NotFoundAppError(serverMessage ?? AppStrings.code404Message.toString());

    case 409:
      return ConflictAppError(serverMessage ?? AppStrings.code409Message.toString());

    case 422:
      return ValidationAppError(serverMessage ?? AppStrings.code422Message.toString());

    case 429:
      return TooManyRequestsAppError(
        serverMessage ?? AppStrings.code429Message.toString(),
      );

    case 500:
    case 502:
    case 503:
    case 504:
      return ServiceUnavailableAppError(
        serverMessage ?? AppStrings.code500sMessage.toString(),
      );

    default:
      return UnknownAppError(serverMessage ?? AppStrings.generalErrorMessage.toString());
  }
}