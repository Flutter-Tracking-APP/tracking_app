import 'package:tracking_app/config/network/app_error.dart';
import 'package:tracking_app/core/errors/app_failure.dart';

class Unset {
  const Unset();
}

const Unset unset = Unset();

class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final AppFailure? failure;
  final T? data;

  const BaseState({
    required this.isLoading,
    required this.errorMessage,
    required this.data,
    this.failure,
  });

  const BaseState.initial()
      : this(isLoading: false, errorMessage: null, data: null, failure: null);

  factory BaseState.loading({T? data}) =>
      BaseState(isLoading: true, errorMessage: null, data: data, failure: null);

  factory BaseState.success(T data) =>
      BaseState(isLoading: false, errorMessage: null, data: data, failure: null);

  factory BaseState.error(String message, {AppFailure? failure, T? data}) =>
      BaseState(
        isLoading: false,
        errorMessage: message,
        failure: failure ?? ServerFailure(error: AppError.general, message: message),
        data: data,
      );

  factory BaseState.failure(AppFailure failure, {T? data}) => BaseState(
        isLoading: false,
        errorMessage: failure is ServerFailure ? failure.message : null,
        failure: failure,
        data: data,
      );

  BaseState<T> copyWith({
    bool? isLoading,
    Object? data = unset,
    Object? errorMessage = unset,
    Object? failure = unset,
  }) {
    final newFailure =
        identical(failure, unset) ? this.failure : failure as AppFailure?;
    final newErrorMessage = identical(errorMessage, unset)
        ? (identical(failure, unset)
            ? this.errorMessage
            : (newFailure is ServerFailure ? newFailure.message : null))
        : errorMessage as String?;

    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: identical(data, unset) ? this.data : data as T?,
      errorMessage: newErrorMessage,
      failure: newFailure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseState<T> &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          failure == other.failure &&
          data == other.data;

  @override
  int get hashCode => Object.hash(isLoading, errorMessage, failure, data);

  @override
  String toString() =>
      'BaseState(isLoading: $isLoading, data: $data, errorMessage: $errorMessage, failure: $failure)';
}
