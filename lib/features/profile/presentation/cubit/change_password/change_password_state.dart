import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base/base_state.dart';

class ChangePasswordState extends Equatable {
  final BaseState<String> changePasswordState;
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmNewPasswordVisible;

  const ChangePasswordState({
    this.changePasswordState = const BaseState.initial(),
    this.isCurrentPasswordVisible = false,
    this.isNewPasswordVisible = false,
    this.isConfirmNewPasswordVisible = false,
  });

  ChangePasswordState copyWith({
    BaseState<String>? changePasswordState,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmNewPasswordVisible,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
      isCurrentPasswordVisible:
          isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmNewPasswordVisible:
          isConfirmNewPasswordVisible ?? this.isConfirmNewPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    changePasswordState,
    isCurrentPasswordVisible,
    isNewPasswordVisible,
    isConfirmNewPasswordVisible,
  ];
}
