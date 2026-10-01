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
      expect(failure1.props, equals([AppError.noConnection]));
    });

    test('ServerMessageFailure supports value equality', () {
      const failure1 = ServerMessageFailure('Invalid credentials');
      const failure2 = ServerMessageFailure('Invalid credentials');
      const failure3 = ServerMessageFailure('Not found');

      expect(failure1, equals(failure2));
      expect(failure1, isNot(equals(failure3)));
      expect(failure1.message, equals('Invalid credentials'));
      expect(failure1.props, equals(['Invalid credentials']));
    });
  });
}
