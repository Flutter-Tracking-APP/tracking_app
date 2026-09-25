import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/config/network/network_constants.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/core/const/endpoints.dart';
import 'package:tracking_app/features/auth/data/models/refresh_token_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/refresh_token_response_dto.dart';

@lazySingleton
class TokenRefreshInterceptor extends Interceptor {
  final SessionService _sessionService;
  final Dio _refreshDio;
  Dio Function()? dioProvider;

  Completer<bool>? _refreshCompleter;

  TokenRefreshInterceptor(
    this._sessionService,
    @Named('refreshDio') this._refreshDio,
  );

  Dio get _mainDio => dioProvider != null ? dioProvider!() : getIt<Dio>();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (_isNonRetryable(err.requestOptions)) {
      if (_isRefreshTokenRequest(err.requestOptions)) {
        await _performLogout();
      }
      return handler.next(err);
    }

    final currentToken = await _sessionService.getToken();
    final requestToken = _extractBearerToken(err.requestOptions);

    if (currentToken.isNotEmpty && currentToken != requestToken) {
      return _retryRequest(err.requestOptions, currentToken, handler);
    }

    final refreshSuccess = await _orchestrateRefresh();
    if (!refreshSuccess) {
      await _performLogout();
      return handler.next(err);
    }

    final newToken = await _sessionService.getToken();
    return _retryRequest(err.requestOptions, newToken, handler);
  }

  bool _isNonRetryable(RequestOptions options) {
    final alreadyRetried = options.extra[NetworkConstants.isRetry] == true;
    return alreadyRetried || _isRefreshTokenRequest(options);
  }

  bool _isRefreshTokenRequest(RequestOptions options) {
    return options.path.contains(Endpoints.refreshToken);
  }

  String? _extractBearerToken(RequestOptions options) {
    final authHeader = options.headers['Authorization']?.toString();
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return null;
    }
    return authHeader.substring(7).trim();
  }

  Future<bool> _orchestrateRefresh() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final success = await _executeTokenRefresh();
      completer.complete(success);
      return success;
    } catch (e, stackTrace) {
      log('Token refresh failed', error: e, stackTrace: stackTrace);
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<bool> _executeTokenRefresh() async {
    final storedRefreshToken = await _sessionService.getRefreshToken();
    if (storedRefreshToken.isEmpty) {
      return false;
    }

    final requestDto = RefreshTokenRequestDto(
      refreshToken: storedRefreshToken,
    );

    final response = await _refreshDio.post<Map<String, dynamic>>(
      Endpoints.refreshToken,
      data: requestDto.toJson(),
    );

    if (response.statusCode != 200 || response.data == null) {
      return false;
    }

    final responseDto = RefreshTokenResponseDto.fromJson(response.data!);
    final data = responseDto.data;
    if (!responseDto.status || data == null) {
      return false;
    }

    await _sessionService.updateTokens(
      token: data.token,
      refreshToken: data.refreshToken,
    );
    return true;
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
    ErrorInterceptorHandler handler,
  ) async {
    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.extra[NetworkConstants.isRetry] = true;

    try {
      final response = await _mainDio.fetch(requestOptions);
      return handler.resolve(response);
    } on DioException catch (dioError) {
      return handler.next(dioError);
    } catch (e) {
      return handler.next(
        DioException(
          requestOptions: requestOptions,
          error: e,
        ),
      );
    }
  }

  Future<void> _performLogout() async {
    try {
      await _sessionService.clearSession();
      AppRouter.router.go(AppRoutes.login);
    } catch (e, stackTrace) {
      log('Automatic logout failed', error: e, stackTrace: stackTrace);
    }
  }
}
