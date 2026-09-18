import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/params/apply_driver_params.dart';

class ApplyDriverRequestDto {
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

  const ApplyDriverRequestDto({
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

  factory ApplyDriverRequestDto.fromDomain(ApplyDriverParams params) {
    return ApplyDriverRequestDto(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      confirmPassword: params.confirmPassword,
      gender: params.gender,
      nid: params.nid,
      nidImage: params.nidImage,
      vehicleTypeId: params.vehicleTypeId,
      vehiclePlateNumber: params.vehiclePlateNumber,
      vehicleCapacity: params.vehicleCapacity,
      licenceImage: params.licenceImage,
      fcmToken: params.fcmToken,
    );
  }

  Future<FormData> toFormData() async {
    final nidFileName = nidImage.path.split(Platform.pathSeparator).last;
    final licenceFileName = licenceImage.path
        .split(Platform.pathSeparator)
        .last;

    return FormData.fromMap({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
      'gender': gender,
      'nid': nid,
      'nidImage': await MultipartFile.fromFile(
        nidImage.path,
        filename: nidFileName,
      ),
      'vehicleTypeId': vehicleTypeId,
      'vehiclePlateNumber': vehiclePlateNumber,
      'vehicleCapacity': vehicleCapacity,
      'licenceImage': await MultipartFile.fromFile(
        licenceImage.path,
        filename: licenceFileName,
      ),
      'fcmToken': fcmToken,
    });
  }
}
