import 'dart:io';
import 'package:equatable/equatable.dart';

class ApplyDriverParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final int gender;
  final String nid;
  final File nidImage;
  final String vehicleTypeId;
  final String vehiclePlateNumber;
  final int vehicleCapacity;
  final File licenceImage;
  final String fcmToken;

  const ApplyDriverParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.gender,
    required this.nid,
    required this.nidImage,
    required this.vehicleTypeId,
    required this.vehiclePlateNumber,
    required this.vehicleCapacity,
    required this.licenceImage,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    password,
    confirmPassword,
    gender,
    nid,
    nidImage.path,
    vehicleTypeId,
    vehiclePlateNumber,
    vehicleCapacity,
    licenceImage.path,
    fcmToken,
  ];
}
