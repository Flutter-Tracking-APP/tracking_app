import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';

sealed class ProfileEvents {
  const ProfileEvents();
}

final class GetProfileEvent extends ProfileEvents {
  const GetProfileEvent();
}

final class GetVehicleInfoEvent extends ProfileEvents {
  const GetVehicleInfoEvent();
}

final class UpdateProfileLocallyEvent extends ProfileEvents {
  final UserProfileEntity profile;
  const UpdateProfileLocallyEvent(this.profile);
}

final class LogoutEvent extends ProfileEvents {
  const LogoutEvent();
}
