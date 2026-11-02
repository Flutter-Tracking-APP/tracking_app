import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';

class ProfileState extends Equatable {
  final BaseState<UserProfileEntity> profileState;
  final BaseState<VehicleInfoEntity> vehicleInfoState;
  final BaseState<bool> logoutState;

  const ProfileState({
    this.profileState = const BaseState.initial(),
    this.vehicleInfoState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
  });

  ProfileState copyWith({
    BaseState<UserProfileEntity>? profileState,
    BaseState<VehicleInfoEntity>? vehicleInfoState,
    BaseState<bool>? logoutState,
  }) {
    return ProfileState(
      profileState: profileState ?? this.profileState,
      vehicleInfoState: vehicleInfoState ?? this.vehicleInfoState,
      logoutState: logoutState ?? this.logoutState,
    );
  }

  @override
  List<Object?> get props => [profileState, vehicleInfoState, logoutState];
}
