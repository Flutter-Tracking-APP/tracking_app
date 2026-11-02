import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/client/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/data_sources/contract/remote/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';
import 'package:tracking_app/features/auth/data/models/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/reset_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/request/login_request.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return await _apiClient.login(request);
  }

  @override
  Future<ForgetPasswordResponseDto> forgotPassword({required String email}) {
    final request = ForgetPasswordRequestDto(email: email);

    return _apiClient.forgotPassword(request);
  }

  @override
  Future<VerifyOtpResponseDto> verifyOtp({
    required String email,
    required String otp,
  }) {
    final request = VerifyOtpRequestDto(email: email, otp: otp);

    return _apiClient.verifyOtp(request);
  }

  @override
  Future<ResetPasswordResponseDto> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    final request = ResetPasswordRequestDto(
      otpToken: otpToken,
      password: password,
      confirmPassword: confirmPassword,
    );

    return _apiClient.resetPassword(request);
  }
}
