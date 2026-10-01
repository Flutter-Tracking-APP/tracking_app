import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';

void main() {
  group('BaseState Tests', () {
    test('initial factory sets default values', () {
      const state = BaseState<String>.initial();
      expect(state.isLoading, isFalse);
      expect(state.data, isNull);
      expect(state.errorMessage, isNull);
      expect(state.failure, isNull);
    });

    test('loading factory sets isLoading to true and preserves data', () {
      final state = BaseState<String>.loading(data: 'existing');
      expect(state.isLoading, isTrue);
      expect(state.data, equals('existing'));
      expect(state.errorMessage, isNull);
      expect(state.failure, isNull);
    });

    test('success factory sets data and resets loading and errors', () {
      final state = BaseState<String>.success('hello');
      expect(state.isLoading, isFalse);
      expect(state.data, equals('hello'));
      expect(state.errorMessage, isNull);
      expect(state.failure, isNull);
    });

    test('error factory populates failure with ServerMessageFailure if omitted', () {
      final state = BaseState<String>.error('something broke');
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, equals('something broke'));
      expect(state.failure, equals(const ServerMessageFailure('something broke')));
    });

    test('failure factory maps ServerMessageFailure message to errorMessage', () {
      const failure = ServerMessageFailure('Server error');
      final state = BaseState<String>.failure(failure);
      expect(state.isLoading, isFalse);
      expect(state.failure, equals(failure));
      expect(state.errorMessage, equals('Server error'));
    });

    test('failure factory keeps errorMessage null for NetworkFailure', () {
      const failure = NetworkFailure(AppError.noConnection);
      final state = BaseState<String>.failure(failure);
      expect(state.isLoading, isFalse);
      expect(state.failure, equals(failure));
      expect(state.errorMessage, isNull);
    });

    group('copyWith sentinel and null-handling', () {
      test('preserves existing values when arguments are omitted', () {
        const state = BaseState<String>(
          isLoading: false,
          errorMessage: 'Old Error',
          failure: ServerMessageFailure('Old Error'),
          data: 'Initial data',
        );

        final copy = state.copyWith(isLoading: true);

        expect(copy.isLoading, isTrue);
        expect(copy.data, equals('Initial data'));
        expect(copy.errorMessage, equals('Old Error'));
        expect(copy.failure, equals(const ServerMessageFailure('Old Error')));
      });

      test('clearing failure via failure: null clears both failure and errorMessage', () {
        const state = BaseState<String>(
          isLoading: false,
          errorMessage: 'Old Error',
          failure: ServerMessageFailure('Old Error'),
          data: 'Initial data',
        );

        final copy = state.copyWith(failure: null);

        expect(copy.failure, isNull);
        expect(copy.errorMessage, isNull);
        expect(copy.data, equals('Initial data'));
      });

      test('explicitly passing errorMessage: null clears errorMessage', () {
        const state = BaseState<String>(
          isLoading: false,
          errorMessage: 'Old Error',
          failure: ServerMessageFailure('Old Error'),
          data: 'Initial data',
        );

        final copy = state.copyWith(errorMessage: null);

        expect(copy.errorMessage, isNull);
        expect(copy.failure, equals(const ServerMessageFailure('Old Error')));
      });

      test('updating failure with ServerMessageFailure automatically aligns errorMessage', () {
        const state = BaseState<String>.initial();

        final copy = state.copyWith(
          failure: const ServerMessageFailure('New failure message'),
        );

        expect(copy.failure, equals(const ServerMessageFailure('New failure message')));
        expect(copy.errorMessage, equals('New failure message'));
      });

      test('supports value equality', () {
        final state1 = BaseState<String>.error('Error');
        final state2 = BaseState<String>.error('Error');
        final state3 = BaseState<String>.initial();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
        expect(state1, isNot(equals(state3)));
      });
    });
  });
}
