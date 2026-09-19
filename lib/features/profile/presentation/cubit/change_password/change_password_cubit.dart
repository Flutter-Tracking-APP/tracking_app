import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/change_password/change_password_state.dart';

@injectable
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;
  final SessionService _sessionService;

  ChangePasswordCubit(this._changePasswordUseCase, this._sessionService)
    : super(const ChangePasswordState());

  void doEvent(ChangePasswordEvents event) {
    switch (event) {
      case ToggleCurrentPasswordVisibilityEvent():
        emit(
          state.copyWith(
            isCurrentPasswordVisible: !state.isCurrentPasswordVisible,
          ),
        );
      case ToggleNewPasswordVisibilityEvent():
        emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
      case ToggleConfirmNewPasswordVisibilityEvent():
        emit(
          state.copyWith(
            isConfirmNewPasswordVisible: !state.isConfirmNewPasswordVisible,
          ),
        );
      case SubmitChangePasswordEvent(params: final params):
        _submitChangePassword(params);
    }
  }

  Future<void> _submitChangePassword(ChangePasswordParams params) async {
    emit(state.copyWith(changePasswordState: BaseState.loading()));
    final result = await _changePasswordUseCase.call(params);
    switch (result) {
      case Success(data: final message):
        await _sessionService.clearSession();
        emit(state.copyWith(changePasswordState: BaseState.success(message)));
      case Failure(error: final error, message: final msg):
        emit(
          state.copyWith(
            changePasswordState: BaseState.error(msg ?? error.name),
          ),
        );
    }
  }
}
