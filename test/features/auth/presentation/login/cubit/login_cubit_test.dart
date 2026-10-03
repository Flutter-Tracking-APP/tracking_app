import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/user_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/cubit/login_event.dart';

class FakeAuthRepo implements AuthRepository {
  ApiResults<LoginEntity>? loginResult;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe) async =>
      loginResult!;

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) async =>
      const Success(null);

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async =>
      const Success({});

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) async =>
      const Success(null);
}

void main() {
  group('LoginCubit Unit Tests', () {
    late FakeAuthRepo repo;
    late LoginUseCase useCase;
    late LoginCubit cubit;

    const dummyUser = UserEntity(
      id: 'u-1',
      name: 'Ali Hassan',
      email: 'ali@example.com',
      phone: '01012345678',
    );
    const dummyLogin = LoginEntity(
      token: 'jwt-token',
      refreshToken: 'refresh-jwt-token',
      user: dummyUser,
    );

    setUp(() {
      repo = FakeAuthRepo();
      useCase = LoginUseCase(repo);
      cubit = LoginCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state.isFormValid, isFalse);
      expect(cubit.state.rememberMe, isFalse);
      expect(cubit.state.login.isLoading, isFalse);
      expect(cubit.state.login.data, isNull);
    });

    test('updates rememberMe on RememberMeChanged event', () async {
      cubit.doEvent(RememberMeChanged(true));
      await pumpEventQueue();

      expect(cubit.state.rememberMe, isTrue);
    });

    test('updates isFormValid on FormValidityChanged event', () async {
      cubit.doEvent(FormValidityChanged(true));
      await pumpEventQueue();

      expect(cubit.state.isFormValid, isTrue);
    });

    test('does not login if isFormValid is false', () async {
      repo.loginResult = const Success(dummyLogin);

      cubit.doEvent(LoginSubmitted(email: 'ali@example.com', password: 'P@ssw0rd123'));
      await pumpEventQueue();

      expect(cubit.state.login.isLoading, isFalse);
      expect(cubit.state.login.data, isNull);
    });

    test('emits loading then success and triggers UI events on LoginSubmitted success', () async {
      repo.loginResult = const Success(dummyLogin);

      final uiEvents = <LoginUIEvent>[];
      final sub = cubit.uiStream.listen(uiEvents.add);

      cubit.doEvent(FormValidityChanged(true));
      cubit.doEvent(LoginSubmitted(email: 'ali@example.com', password: 'P@ssw0rd123'));
      await pumpEventQueue();

      expect(cubit.state.login.isLoading, isFalse);
      expect(cubit.state.login.data, equals(dummyLogin));
      expect(uiEvents, hasLength(2));
      expect(uiEvents[0], isA<LoginSuccessMessage>());
      expect(uiEvents[1], isA<LoginSuccess>());

      await sub.cancel();
    });

    test('emits loading then failure and triggers ShowMessage on LoginSubmitted failure', () async {
      const failure = ServerFailure(
        error: AppError.unauthorized,
        message: 'Invalid email or password',
      );
      repo.loginResult = const FailureResponse(failure);

      final uiEvents = <LoginUIEvent>[];
      final sub = cubit.uiStream.listen(uiEvents.add);

      cubit.doEvent(FormValidityChanged(true));
      cubit.doEvent(LoginSubmitted(email: 'ali@example.com', password: 'WrongPass'));
      await pumpEventQueue();

      expect(cubit.state.login.isLoading, isFalse);
      expect(cubit.state.login.failure, equals(failure));
      expect(cubit.state.login.errorMessage, equals('Invalid email or password'));
      expect(uiEvents, hasLength(1));
      expect(uiEvents.first, isA<ShowMessage>());
      final showMsg = uiEvents.first as ShowMessage;
      expect(showMsg.message, equals('Invalid email or password'));
      expect(showMsg.failure, equals(failure));

      await sub.cancel();
    });
  });
}
