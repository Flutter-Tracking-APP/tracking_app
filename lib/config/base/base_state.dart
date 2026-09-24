class Unset {
  const Unset();
}

const Unset unset = Unset();

class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final T? data;

  const BaseState({
    required this.isLoading,
    required this.errorMessage,
    required this.data,
  });

  const BaseState.initial()
    : this(isLoading: false, errorMessage: null, data: null);

  factory BaseState.loading({T? data}) =>
      BaseState(isLoading: true, errorMessage: null, data: data);

  factory BaseState.success(T data) =>
      BaseState(isLoading: false, errorMessage: null, data: data);

  factory BaseState.error(String message, {T? data}) =>
      BaseState(isLoading: false, errorMessage: message, data: data);

  BaseState<T> copyWith({
    bool? isLoading,
    Object? data = unset,
    Object? errorMessage = unset,
  }) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: identical(data, unset) ? this.data : data as T?,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  String toString() =>
      'BaseState(isLoading: $isLoading, data: $data, errorMessage: $errorMessage)';
}
