
import 'package:tracking_app/features/auth/data/models/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';
import 'package:tracking_app/features/auth/data/models/reset_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/request/login_request.dart';

abstract interface class AuthRemoteDataSource {

  Future<LoginResponse> login(LoginRequest request);
  Future<ForgetPasswordResponseDto> forgotPassword({required String email});

  Future<VerifyOtpResponseDto> verifyOtp({
    required String email,
    required String otp,
  });

  Future<ResetPasswordResponseDto> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  });
}
