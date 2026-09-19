import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';

class ProfileState extends Equatable {
  final BaseState<UserProfileEntity> profileState;
  final BaseState<bool> logoutState;

  const ProfileState({
    this.profileState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
  });

  ProfileState copyWith({
    BaseState<UserProfileEntity>? profileState,
    BaseState<bool>? logoutState,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      logoutState: logoutState ?? this.logoutState,
    );
  }

  @override
  List<Object?> get props => [profileState, logoutState];
}
