import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/domain/entities/login_entity.dart';
import 'package:tracking_app/features/auth/domain/params/login_params.dart';

abstract interface class AuthRepository {
  Future<ApiResults<LoginEntity>> login(LoginParams params, bool rememberMe);
  Future<ApiResults<void>> forgotPassword({required String email});

  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  });
}
