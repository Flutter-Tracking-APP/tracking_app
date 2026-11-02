import 'dart:io';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/params/update_profile_params.dart';

sealed class EditProfileEvents {
  const EditProfileEvents();
}

final class InitEditProfileEvent extends EditProfileEvents {
  final UserProfileEntity profile;
  const InitEditProfileEvent(this.profile);
}

final class PickAvatarEvent extends EditProfileEvents {
  final File? file;
  const PickAvatarEvent([this.file]);
}

final class SelectEditGenderEvent extends EditProfileEvents {
  final int gender;
  const SelectEditGenderEvent(this.gender);
}

final class SubmitEditProfileEvent extends EditProfileEvents {
  final UpdateProfileParams params;
  const SubmitEditProfileEvent(this.params);
}
