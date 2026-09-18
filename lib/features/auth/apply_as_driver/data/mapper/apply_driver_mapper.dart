import 'package:tracking_app/features/auth/apply_as_driver/data/models/response/apply_driver_response_dto.dart';
import 'package:tracking_app/features/auth/apply_as_driver/domain/entities/driver_application_entity.dart';

extension ApplyDriverResponseDtoMapper on ApplyDriverResponseDto {
  DriverApplicationEntity toEntity() {
    return DriverApplicationEntity(
      id: data?.id ?? '',
      name: data?.name ?? '',
      email: data?.email ?? '',
      phone: data?.phone ?? '',
      role: data?.role,
      createdAt: data?.createdAt ?? '',
      updatedAt: data?.updatedAt ?? '',
      gender: data?.gender ?? '',
      notificationStatus: data?.notifcationStatus ?? '',
    );
  }
}

extension DriverDataDtoMapper on DriverDataDto {
  DriverApplicationEntity toEntity() {
    return DriverApplicationEntity(
      id: id ?? '',
      name: name ?? '',
      email: email ?? '',
      phone: phone ?? '',
      role: role,
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      gender: gender ?? '',
      notificationStatus: notifcationStatus ?? '',
    );
  }
}
