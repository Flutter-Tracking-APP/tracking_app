abstract class AppError {
  final Exception? exception;
  final String? message;

  AppError(this.exception, this.message);
}

class TimeoutAppError extends AppError {
  TimeoutAppError(super.exception, super.message);
}

class BadCredentialsAppError extends AppError {
  BadCredentialsAppError(super.exception, super.message);
}

class ForceLoginAppError extends AppError {
  ForceLoginAppError(String message) : super(null, message);
}

class BadRequestAppError extends AppError {
  BadRequestAppError(String message) : super(null, message);
}

class ValidationAppError extends AppError {
  ValidationAppError(String message) : super(null, message);
}

class ConflictAppError extends AppError {
  ConflictAppError(String message) : super(null, message);
}

class ForbiddenAppError extends AppError {
  ForbiddenAppError(String message) : super(null, message);
}

class NotFoundAppError extends AppError {
  NotFoundAppError(String message) : super(null, message);
}

class TooManyRequestsAppError extends AppError {
  TooManyRequestsAppError(String message) : super(null, message);
}

class ServiceUnavailableAppError extends AppError {
  ServiceUnavailableAppError(String message) : super(null, message);
}

class ServerAppError extends AppError {
  ServerAppError(String message) : super(null, message);
}

class UnknownAppError extends AppError {
  UnknownAppError(String message) : super(null, message);
}

class NoInternetAppError extends AppError {
  NoInternetAppError(String message) : super(null, message);
}

class IgnoreAppError extends AppError {
  IgnoreAppError() : super(null, null);
}

class BadResponseAppError extends AppError{
  BadResponseAppError(String message): super(null, message);
}