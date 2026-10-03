import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';

void main() {
  group('AppFailure Tests', () {
    test('NetworkFailure supports value equality', () {
      const failure1 = NetworkFailure(AppError.noConnection);
      const failure2 = NetworkFailure(AppError.noConnection);
      const failure3 = NetworkFailure(AppError.timeout);

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
      expect(failure1.error, equals(AppError.noConnection));
      expect(failure1.message, isNull);
      expect(failure1.props, equals([AppError.noConnection]));
    });

    test('ServerFailure supports value equality with message and error', () {
      const failure1 = ServerFailure(
        error: AppError.badRequest,
        message: 'Invalid credentials',
      );
      const failure2 = ServerFailure(
        error: AppError.badRequest,
        message: 'Invalid credentials',
      );
      const failure3 = ServerFailure(
        error: AppError.notFound,
        message: 'Not found',
      );
      const failureNullMessage = ServerFailure(
        error: AppError.server,
        message: null,
      );

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
      expect(failure1.error, equals(AppError.badRequest));
      expect(failure1.message, equals('Invalid credentials'));
      expect(failure1.props, equals([AppError.badRequest, 'Invalid credentials']));

      expect(failureNullMessage.error, equals(AppError.server));
      expect(failureNullMessage.message, isNull);
      expect(failureNullMessage.props, equals([AppError.server, null]));
    });
  });
}
