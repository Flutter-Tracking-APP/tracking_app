import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';

sealed class ApiResults<T> {
  const ApiResults();
}

class Success<T> extends ApiResults<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResults<T> {
  final String? message;
  final AppError error;
  final AppFailure? _failure;

  const Failure(this.message, this.error, [this._failure]);

  Failure.fromFailure(AppFailure failure)
      : _failure = failure,
        message = failure is ServerMessageFailure ? failure.message : null,
        error = failure is NetworkFailure ? failure.error : AppError.general;

  AppFailure get failure =>
      _failure ??
      (message != null && message!.isNotEmpty
          ? ServerMessageFailure(message!)
          : NetworkFailure(error));
}
