import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_state.dart';

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;

  EditProfileCubit(this._updateProfileUseCase)
    : super(const EditProfileState());

  void doEvent(EditProfileEvents event) {
    switch (event) {
      case InitEditProfileEvent(profile: final profile):
        emit(state.copyWith(selectedGender: profile.gender));
      case PickAvatarEvent(file: final file):
        emit(state.copyWith(avatarFile: file));
      case SelectEditGenderEvent(gender: final gender):
        emit(state.copyWith(selectedGender: gender));
      case SubmitEditProfileEvent(params: final params):
        _submitUpdateProfile(params);
    }
  }

  Future<void> _submitUpdateProfile(UpdateProfileParams params) async {
    emit(state.copyWith(updateProfileState: BaseState.loading()));
    final result = await _updateProfileUseCase.call(params);
    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(updateProfileState: BaseState.success(message)));
      case Failure(error: final error, message: final msg):
        emit(
          state.copyWith(
            updateProfileState: BaseState.error(msg ?? error.name),
          ),
        );
    }
  }
}
