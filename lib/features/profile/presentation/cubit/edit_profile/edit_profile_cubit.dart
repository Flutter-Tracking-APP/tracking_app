import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/base/base_cubit.dart';
import 'package:tracking_app/config/base/base_event.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/config/di/image_picker_service.dart';
import 'package:tracking_app/config/network/api_results.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/cubit/edit_profile/edit_profile_state.dart';

@injectable
class EditProfileCubit extends BaseCubit<EditProfileState, BaseEvent> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final ImagePickerService _imagePickerService;

  EditProfileCubit(this._updateProfileUseCase, this._imagePickerService)
    : super(const EditProfileState());

  void doEvent(EditProfileEvents event) {
    switch (event) {
      case InitEditProfileEvent(profile: final profile):
        emit(state.copyWith(selectedGender: profile.gender));
      case PickAvatarEvent(file: final file):
        _pickAvatar(file);
      case SelectEditGenderEvent(gender: final gender):
        emit(state.copyWith(selectedGender: gender));
      case SubmitEditProfileEvent(params: final params):
        _submitUpdateProfile(params);
    }
  }

  Future<void> _pickAvatar(File? file) async {
    if (file != null) {
      emit(state.copyWith(avatarFile: file));
      return;
    }
    final picked = await _imagePickerService.pickImageFromGallery();
    if (picked != null) {
      emit(state.copyWith(avatarFile: picked));
    }
  }

  Future<void> _submitUpdateProfile(UpdateProfileParams params) async {
    emit(state.copyWith(updateProfileState: BaseState.loading()));
    final result = await _updateProfileUseCase.call(params);
    switch (result) {
      case Success(data: final message):
        emit(state.copyWith(updateProfileState: BaseState.success(message)));
        emitEvent(DisplaySuccess(message));
      case Failure(error: final error, message: final msg):
        final errorMsg = msg ?? error.name;
        emit(state.copyWith(updateProfileState: BaseState.error(errorMsg)));
        emitEvent(DisplayError(errorMsg));
    }
  }
}
