import 'package:equatable/equatable.dart';

class DriverApplicationEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? role;
  final String createdAt;
  final String updatedAt;
  final String gender;
  final String notificationStatus;

  const DriverApplicationEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
    required this.notificationStatus,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    role,
    createdAt,
    updatedAt,
    gender,
    notificationStatus,
  ];
}
