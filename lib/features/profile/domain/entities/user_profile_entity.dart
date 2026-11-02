import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int gender;
  final String? profilePictureUrl;

  const UserProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.profilePictureUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phoneNumber,
    gender,
    profilePictureUrl,
  ];
}
