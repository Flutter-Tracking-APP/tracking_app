import 'package:equatable/equatable.dart';
import 'package:tracking_app/config/network/app_error.dart';

sealed class AppFailure extends Equatable {
  const AppFailure();

  AppError get error;
  String? get message => null;

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends AppFailure {
  @override
  final AppError error;

  const NetworkFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class ServerFailure extends AppFailure {
  @override
  final AppError error;
  @override
  final String? message;

  const ServerFailure({
    required this.error,
    this.message,
  });

  @override
  List<Object?> get props => [error, message];
}
