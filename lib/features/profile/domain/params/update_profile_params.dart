import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final int gender;
  final String profilePictureUrl;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phoneNumber,
    gender,
    profilePictureUrl,
  ];
}
