import 'package:equatable/equatable.dart';

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmNewPassword];
}
