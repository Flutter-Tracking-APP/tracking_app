import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/network/safe_call.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/request/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SessionService _sessionService;
  // final DeviceIdService _deviceIdService;
  // final PushNotificationsServices _pushNotificationsServices;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._sessionService,
    // this._deviceIdService,
    // this._pushNotificationsServices,
  );

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe) {
    return safeCall(() async {
      final request = LoginRequest(
        email: params.email,
        password: params.password,
        // fcmToken: fcmToken ?? '',
        // deviceId: deviceId,
      );
      final response = await _remoteDataSource.login(request);
      final loginEntity = response.toEntity();

      await _sessionService.setRememberMe(rememberMe);

      await _sessionService.setGuestMode(false);

      await _sessionService.saveTokens(
        token: loginEntity.token,
        refreshToken: loginEntity.refreshToken,
        rememberMe: rememberMe,
      );

      return Success(loginEntity);
    });
  }

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) {
    return safeCall(() async {
      await _remoteDataSource.forgotPassword(email: email);

      return Success(null);
    });
  }

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    return safeCall(() async {
      await _remoteDataSource.resetPassword(
        otpToken: otpToken,
        password: password,
        confirmPassword: confirmPassword,
      );

      return Success(null);
    });
  }

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) {
  return  safeCall(() async {
      VerifyOtpResponseDto verifyOtpResponse = await _remoteDataSource
          .verifyOtp(email: email, otp: otp);

      return Success<Map<String, dynamic>>(verifyOtpResponse.data);
    });
  }
}
