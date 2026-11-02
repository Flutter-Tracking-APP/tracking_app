import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/repositories/apply_driver_repository.dart';

@injectable
class ApplyAsDriverUseCase {
  final ApplyDriverRepository _repository;

  ApplyAsDriverUseCase(this._repository);

  Future<ApiResults<DriverApplicationEntity>> call(
    ApplyDriverParams params,
  ) async {
    return await _repository.applyAsDriver(params);
  }
}
