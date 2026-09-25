import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/interceptors/token_refresh_interceptor.dart';
import 'package:tracking_app/config/network/network_constants.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/core/const/endpoints.dart';

class FakeSessionService implements SessionService {
  String currentToken;
  String currentRefreshToken;
  bool isCleared = false;
  int updateTokensCallCount = 0;

  FakeSessionService({this.currentToken = '', this.currentRefreshToken = ''});

  @override
  Future<String> getToken() async => currentToken;

  @override
  Future<String> getRefreshToken() async => currentRefreshToken;

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {
    updateTokensCallCount++;
    currentToken = token;
    currentRefreshToken = refreshToken;
  }

  @override
  Future<void> clearSession() async {
    isCleared = true;
    currentToken = '';
    currentRefreshToken = '';
  }

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => true;

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {
    currentToken = token;
    currentRefreshToken = refreshToken;
  }

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> setRememberMe(bool value) async {}
}

class TestErrorHandler extends ErrorInterceptorHandler {
  final Completer<Response> resolvedCompleter = Completer<Response>();
  final Completer<DioException> nextCompleter = Completer<DioException>();
  final Completer<DioException> rejectCompleter = Completer<DioException>();

  @override
  void resolve(Response response) {
    if (!resolvedCompleter.isCompleted) {
      resolvedCompleter.complete(response);
    }
  }

  @override
  void next(DioException err) {
    if (!nextCompleter.isCompleted) {
      nextCompleter.complete(err);
    }
  }

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) {
    if (!rejectCompleter.isCompleted) {
      rejectCompleter.complete(err);
    }
  }
}

void main() {
  late FakeSessionService fakeSessionService;
  late Dio refreshDio;
  late Dio mainDio;
  late TokenRefreshInterceptor interceptor;
  late int refreshApiCallCount;
  late Response Function(RequestOptions options)? refreshResponseGenerator;
  late Response Function(RequestOptions options)? mainResponseGenerator;

  setUp(() {
    fakeSessionService = FakeSessionService(
      currentToken: 'old_access_token',
      currentRefreshToken: 'valid_refresh_token',
    );
    refreshApiCallCount = 0;
    refreshResponseGenerator = null;
    mainResponseGenerator = null;

    refreshDio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
    refreshDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
      if (options.path.contains(Endpoints.refreshToken)) {
        refreshApiCallCount++;
        if (refreshResponseGenerator != null) {
          return refreshResponseGenerator!(options);
        }
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'status': true,
            'code': 200,
            'message': 'Token refreshed',
            'data': {
              'token': 'new_access_token',
              'refreshToken': 'new_refresh_token',
            },
          },
        );
      }
      return Response(requestOptions: options, statusCode: 404);
    });

    mainDio = Dio(BaseOptions(baseUrl: Endpoints.baseUrl));
    mainDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
      if (mainResponseGenerator != null) {
        return mainResponseGenerator!(options);
      }
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'success': true},
      );
    });

    interceptor = TokenRefreshInterceptor(fakeSessionService, refreshDio)
      ..dioProvider = () => mainDio;
  });

  group('TokenRefreshInterceptor Tests', () {
    test('Non-401 error should pass directly to handler.next', () async {
      final handler = TestErrorHandler();
      final exception = DioException(
        requestOptions: RequestOptions(path: '/api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/test'),
          statusCode: 500,
        ),
      );

      await interceptor.onError(exception, handler);

      expect(handler.nextCompleter.isCompleted, isTrue);
      expect(refreshApiCallCount, 0);
    });

    test(
      '401 error on already retried request should pass to next without refresh',
      () async {
        final handler = TestErrorHandler();
        final exception = DioException(
          requestOptions: RequestOptions(
            path: '/api/test',
            extra: {NetworkConstants.isRetry: true},
          ),
          response: Response(
            requestOptions: RequestOptions(path: '/api/test'),
            statusCode: 401,
          ),
        );

        await interceptor.onError(exception, handler);

        expect(handler.nextCompleter.isCompleted, isTrue);
        expect(refreshApiCallCount, 0);
      },
    );

    test(
      '401 error on refreshToken endpoint triggers logout and passes to next',
      () async {
        final handler = TestErrorHandler();
        final exception = DioException(
          requestOptions: RequestOptions(path: Endpoints.refreshToken),
          response: Response(
            requestOptions: RequestOptions(path: Endpoints.refreshToken),
            statusCode: 401,
          ),
        );

        await interceptor.onError(exception, handler);

        expect(handler.nextCompleter.isCompleted, isTrue);
        expect(refreshApiCallCount, 0);
        expect(fakeSessionService.isCleared, isTrue);
      },
    );

    test(
      '401 error with empty refresh token triggers logout and passes to next',
      () async {
        fakeSessionService.currentRefreshToken = '';
        final handler = TestErrorHandler();
        final exception = DioException(
          requestOptions: RequestOptions(
            path: '/api/profile',
            headers: {'Authorization': 'Bearer old_access_token'},
          ),
          response: Response(
            requestOptions: RequestOptions(path: '/api/profile'),
            statusCode: 401,
          ),
        );

        await interceptor.onError(exception, handler);

        expect(handler.nextCompleter.isCompleted, isTrue);
        expect(refreshApiCallCount, 0);
        expect(fakeSessionService.isCleared, isTrue);
      },
    );

    test('Successful 401 refresh updates tokens and retries request', () async {
      final handler = TestErrorHandler();
      final requestOptions = RequestOptions(
        path: '/api/profile',
        headers: {'Authorization': 'Bearer old_access_token'},
      );
      final exception = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      await interceptor.onError(exception, handler);

      expect(handler.resolvedCompleter.isCompleted, isTrue);
      final response = await handler.resolvedCompleter.future;
      expect(response.statusCode, 200);
      expect(refreshApiCallCount, 1);
      expect(fakeSessionService.currentToken, 'new_access_token');
      expect(fakeSessionService.currentRefreshToken, 'new_refresh_token');
      expect(
        requestOptions.headers['Authorization'],
        'Bearer new_access_token',
      );
      expect(requestOptions.extra[NetworkConstants.isRetry], isTrue);
    });

    test(
      'If token was already updated by another call, retries immediately without refresh',
      () async {
        fakeSessionService.currentToken = 'already_updated_token';

        final handler = TestErrorHandler();
        final requestOptions = RequestOptions(
          path: '/api/profile',
          headers: {'Authorization': 'Bearer old_access_token'},
        );
        final exception = DioException(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401),
        );

        await interceptor.onError(exception, handler);

        expect(handler.resolvedCompleter.isCompleted, isTrue);
        expect(refreshApiCallCount, 0); // No refresh call needed!
        expect(
          requestOptions.headers['Authorization'],
          'Bearer already_updated_token',
        );
        expect(requestOptions.extra[NetworkConstants.isRetry], isTrue);
      },
    );

    test(
      'Concurrent 401 errors deduplicate and fire only ONE refresh API call',
      () async {
        final handler1 = TestErrorHandler();
        final handler2 = TestErrorHandler();

        final request1 = RequestOptions(
          path: '/api/profile',
          headers: {'Authorization': 'Bearer old_access_token'},
        );
        final request2 = RequestOptions(
          path: '/api/vehicles',
          headers: {'Authorization': 'Bearer old_access_token'},
        );

        final err1 = DioException(
          requestOptions: request1,
          response: Response(requestOptions: request1, statusCode: 401),
        );
        final err2 = DioException(
          requestOptions: request2,
          response: Response(requestOptions: request2, statusCode: 401),
        );

        // Trigger both simultaneously
        final future1 = interceptor.onError(err1, handler1);
        final future2 = interceptor.onError(err2, handler2);

        await Future.wait([future1, future2]);

        expect(handler1.resolvedCompleter.isCompleted, isTrue);
        expect(handler2.resolvedCompleter.isCompleted, isTrue);
        expect(
          refreshApiCallCount,
          1,
        ); // Only 1 refresh network call was executed!
        expect(fakeSessionService.currentToken, 'new_access_token');
      },
    );

    test(
      'Refresh API failure triggers logout and next for all waiting handlers',
      () async {
        refreshResponseGenerator = (options) => Response(
          requestOptions: options,
          statusCode: 401,
          data: {'status': false, 'message': 'Refresh token expired'},
        );

        final handler = TestErrorHandler();
        final requestOptions = RequestOptions(
          path: '/api/profile',
          headers: {'Authorization': 'Bearer old_access_token'},
        );
        final exception = DioException(
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 401),
        );

        await interceptor.onError(exception, handler);

        expect(handler.nextCompleter.isCompleted, isTrue);
        expect(refreshApiCallCount, 1);
        expect(fakeSessionService.isCleared, isTrue);
      },
    );
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final Future<Response> Function(RequestOptions options) handler;

  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final response = await handler(options);
    final bodyString = response.data is String
        ? response.data as String
        : jsonEncode(response.data);
    return ResponseBody.fromString(
      bodyString,
      response.statusCode ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
