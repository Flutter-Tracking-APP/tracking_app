import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:tracking_app/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

class FakeForgetPasswordAuthRepo implements AuthRepository {
  ApiResults<void>? forgotPasswordResult;
  ApiResults<Map<String, dynamic>>? verifyOtpResult;
  ApiResults<void>? resetPasswordResult;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) async =>
      forgotPasswordResult!;

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async =>
      verifyOtpResult!;

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) async =>
      resetPasswordResult!;
}

void main() {
  group('ForgetPasswordBloc Unit Tests', () {
    late FakeForgetPasswordAuthRepo repo;
    late ForgetPasswordBloc bloc;

    setUp(() {
      repo = FakeForgetPasswordAuthRepo();
      bloc = ForgetPasswordBloc(
        ForgetPasswordUseCase(repo),
        VerifyOtpUseCase(repo),
        ResetPasswordUseCase(repo),
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has email step', () {
      expect(bloc.state.step, equals(ForgetPasswordStep.email));
      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, isNull);
    });

    test('CheckEmailEvent succeeds and transitions to OTP step', () async {
      repo.forgotPasswordResult = const Success(null);

      bloc.add(const CheckEmailEvent('user@example.com'));
      await pumpEventQueue();

      expect(bloc.state.step, equals(ForgetPasswordStep.otp));
      expect(bloc.state.email, equals('user@example.com'));
      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, isNull);
    });

    test('CheckEmailEvent fails with FailureResponse and sets failure', () async {
      const failure = ServerFailure(
        error: AppError.notFound,
        message: 'Email not registered',
      );
      repo.forgotPasswordResult = const FailureResponse(failure);

      bloc.add(const CheckEmailEvent('notfound@example.com'));
      await pumpEventQueue();

      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, equals(failure));
      expect(bloc.state.errorMessage, equals('Email not registered'));
    });

    test('VerifyOtpEvent succeeds and transitions to resetPassword step', () async {
      repo.forgotPasswordResult = const Success(null);
      bloc.add(const CheckEmailEvent('user@example.com'));
      await pumpEventQueue();

      repo.verifyOtpResult = const Success({'otpToken': 'token-123'});
      bloc.add(const VerifyOtpEvent('123456'));
      await pumpEventQueue();

      expect(bloc.state.step, equals(ForgetPasswordStep.resetPassword));
      expect(bloc.state.otpToken, equals('token-123'));
      expect(bloc.state.isLoading, isFalse);
    });

    test('VerifyOtpEvent fails with FailureResponse', () async {
      repo.forgotPasswordResult = const Success(null);
      bloc.add(const CheckEmailEvent('user@example.com'));
      await pumpEventQueue();

      const failure = ServerFailure(
        error: AppError.badRequest,
        message: 'Invalid OTP code',
      );
      repo.verifyOtpResult = const FailureResponse(failure);

      bloc.add(const VerifyOtpEvent('000000'));
      await pumpEventQueue();

      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, equals(failure));
      expect(bloc.state.errorMessage, equals('Invalid OTP code'));
    });

    test('ResetPasswordEvent succeeds', () async {
      repo.forgotPasswordResult = const Success(null);
      bloc.add(const CheckEmailEvent('user@example.com'));
      await pumpEventQueue();

      repo.verifyOtpResult = const Success({'otpToken': 'token-123'});
      bloc.add(const VerifyOtpEvent('123456'));
      await pumpEventQueue();

      repo.resetPasswordResult = const Success(null);
      bloc.add(const ResetPasswordEvent('P@ssw0rd123'));
      await pumpEventQueue();

      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, isNull);
    });

    test('ResetPasswordEvent fails with FailureResponse', () async {
      repo.forgotPasswordResult = const Success(null);
      bloc.add(const CheckEmailEvent('user@example.com'));
      await pumpEventQueue();

      repo.verifyOtpResult = const Success({'otpToken': 'token-123'});
      bloc.add(const VerifyOtpEvent('123456'));
      await pumpEventQueue();

      const failure = ServerFailure(
        error: AppError.badRequest,
        message: 'Password does not meet requirements',
      );
      repo.resetPasswordResult = const FailureResponse(failure);

      bloc.add(const ResetPasswordEvent('weak'));
      await pumpEventQueue();

      expect(bloc.state.isLoading, isFalse);
      expect(bloc.state.failure, equals(failure));
      expect(bloc.state.errorMessage, equals('Password does not meet requirements'));
    });
  });
}
