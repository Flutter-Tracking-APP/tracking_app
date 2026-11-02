import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<ApiResults<void>> execute({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    return _repository.resetPassword(
      otpToken: otpToken,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
