import 'dart:io';
import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final int? gender;
  final File? profilePicture;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    gender,
    profilePicture,
  ];
}
