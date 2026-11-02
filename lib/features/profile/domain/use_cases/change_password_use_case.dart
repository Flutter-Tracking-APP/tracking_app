import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<ApiResults<String>> call(ChangePasswordParams params) {
    return _repository.changePassword(params);
  }
}
