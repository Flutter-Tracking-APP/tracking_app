import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/base_state/base_state.dart';

class EditProfileState extends Equatable {
  final BaseState<String> updateProfileState;
  final File? avatarFile;
  final int selectedGender;

  const EditProfileState({
    this.updateProfileState = const BaseState.initial(),
    this.avatarFile,
    this.selectedGender = 0,
  });

  EditProfileState copyWith({
    BaseState<String>? updateProfileState,
    File? avatarFile,
    int? selectedGender,
  }) {
    return EditProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      avatarFile: avatarFile ?? this.avatarFile,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
    avatarFile?.path,
    selectedGender,
  ];
}
