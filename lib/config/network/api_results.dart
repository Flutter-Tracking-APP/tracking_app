import 'package:tracking_app/config/network/app_error.dart';

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
  const Failure(this.message, this.error);
}
