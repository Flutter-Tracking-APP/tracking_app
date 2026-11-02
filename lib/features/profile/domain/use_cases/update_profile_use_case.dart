import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<ApiResults<String>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}
