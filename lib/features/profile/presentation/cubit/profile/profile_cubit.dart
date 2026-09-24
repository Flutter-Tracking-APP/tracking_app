import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/const/app_router.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/config/session/session_service.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/profile/profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, BaseEvent> {
  final GetProfileUseCase _getProfileUseCase;
  final SessionService _sessionService;

  ProfileCubit(this._getProfileUseCase, this._sessionService)
    : super(const ProfileState());

  void doEvent(ProfileEvents event) {
    switch (event) {
      case GetProfileEvent():
        _getProfile();
      case UpdateProfileLocallyEvent(:final profile):
        emit(state.copyWith(profileState: BaseState.success(profile)));
      case LogoutEvent():
        _logout();
    }
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(
        profileState: BaseState(
          isLoading: true,
          errorMessage: null,
          data: state.profileState.data,
        ),
      ),
    );
    final result = await _getProfileUseCase.call();
    switch (result) {
      case Success(data: final data):
        emit(state.copyWith(profileState: BaseState.success(data)));
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(
          state.copyWith(
            profileState: BaseState(
              isLoading: false,
              errorMessage: errorMsg,
              data: state.profileState.data,
            ),
          ),
        );
        emitEvent(DisplayError(errorMsg));
    }
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    await _sessionService.clearSession();
    emit(state.copyWith(logoutState: BaseState.success(true)));
    emitEvent(const NavigateEvent(AppRoutes.login));
  }
}
