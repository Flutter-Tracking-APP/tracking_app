import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/config/network/safe_call.dart';

void main() {
  group('safeCall Tests', () {
    test('returns Success when callback succeeds', () async {
      final result = await safeCall<String>(() async => const Success('data'));

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, equals('data'));
    });

    test('catches on Exception and returns FailureResponse with parsed failure', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, equals(const NetworkFailure(AppError.timeout)));
    });

    test('does NOT catch Dart Error and lets it rethrow', () async {
      expect(
        () => safeCall<String>(() async {
          throw ArgumentError('Programmer error');
        }),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('errorParser Tests', () {
    test('maps connection timeout to NetworkFailure(AppError.timeout)', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      );
      expect(errorParser(ex), equals(const NetworkFailure(AppError.timeout)));
    });

    test('maps sendTimeout and receiveTimeout to NetworkFailure(AppError.timeout)', () {
      final sendEx = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.sendTimeout,
      );
      final receiveEx = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );

      expect(errorParser(sendEx), equals(const NetworkFailure(AppError.timeout)));
      expect(errorParser(receiveEx), equals(const NetworkFailure(AppError.timeout)));
    });

    test('maps connectionError to NetworkFailure(AppError.noConnection)', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      expect(errorParser(ex), equals(const NetworkFailure(AppError.noConnection)));
    });

    test('maps badCertificate to NetworkFailure(AppError.security)', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badCertificate,
      );
      expect(errorParser(ex), equals(const NetworkFailure(AppError.security)));
    });

    test('maps cancel to NetworkFailure(AppError.cancelled)', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      );
      expect(errorParser(ex), equals(const NetworkFailure(AppError.cancelled)));
    });

    test('maps unknown to NetworkFailure(AppError.unknown)', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
      );
      expect(errorParser(ex), equals(const NetworkFailure(AppError.unknown)));
    });

    test('maps status >= 500 to ServerFailure with null message and AppError.server', () {
      final ex500 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
          data: {'message': 'Internal Server Error'},
        ),
      );

      final ex503 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 503,
          data: {'message': 'Service Unavailable'},
        ),
      );

      expect(
        errorParser(ex500),
        equals(const ServerFailure(error: AppError.server, message: null)),
      );
      expect(
        errorParser(ex503),
        equals(const ServerFailure(error: AppError.server, message: null)),
      );
    });

    test('maps status < 500 to ServerFailure extracting message from message key', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 400,
          data: {'message': 'Invalid input data'},
        ),
      );

      expect(
        errorParser(ex),
        equals(
          const ServerFailure(
            error: AppError.badRequest,
            message: 'Invalid input data',
          ),
        ),
      );
    });

    test('maps status < 500 extracting message from error or msg key', () {
      final exError = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
          data: {'error': 'Unauthorized token'},
        ),
      );
      final exMsg = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 403,
          data: {'msg': 'Forbidden access'},
        ),
      );

      expect(
        errorParser(exError),
        equals(
          const ServerFailure(
            error: AppError.unauthorized,
            message: 'Unauthorized token',
          ),
        ),
      );
      expect(
        errorParser(exMsg),
        equals(
          const ServerFailure(
            error: AppError.forbidden,
            message: 'Forbidden access',
          ),
        ),
      );
    });

    test('maps status < 500 extracting message from errors list', () {
      final exList = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 422,
          data: {
            'errors': [
              {'message': 'Email already taken'},
            ],
          },
        ),
      );

      expect(
        errorParser(exList),
        equals(
          const ServerFailure(
            error: AppError.validation,
            message: 'Email already taken',
          ),
        ),
      );
    });

    test('maps status < 500 with plain String data', () {
      final ex = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
          data: 'Resource not found',
        ),
      );

      expect(
        errorParser(ex),
        equals(
          const ServerFailure(
            error: AppError.notFound,
            message: 'Resource not found',
          ),
        ),
      );
    });

    test('maps status 409 conflict and 429 tooManyRequests', () {
      final ex409 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 409,
          data: {'message': 'Order already claimed'},
        ),
      );
      final ex429 = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 429,
          data: {'message': 'Too many requests'},
        ),
      );

      expect(
        errorParser(ex409),
        equals(
          const ServerFailure(
            error: AppError.conflict,
            message: 'Order already claimed',
          ),
        ),
      );
      expect(
        errorParser(ex429),
        equals(
          const ServerFailure(
            error: AppError.tooManyRequests,
            message: 'Too many requests',
          ),
        ),
      );
    });

    test('maps generic non-Dio exception to NetworkFailure(AppError.unknown)', () {
      final ex = FormatException('Bad format');
      expect(errorParser(ex), equals(const NetworkFailure(AppError.unknown)));
    });
  });
}
