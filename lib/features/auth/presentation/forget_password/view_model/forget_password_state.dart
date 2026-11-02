import 'package:equatable/equatable.dart';

import '../../../../../config/base/base_state.dart';

enum ForgetPasswordStep { email, otp, resetPassword }

enum ForgetPasswordOperation {
  none,
  checkEmail,
  resendOtp,
  verifyOtp,
  resetPassword,
}

// ignore: must_be_immutable
class ForgetPasswordState extends BaseState<dynamic> with Equatable {
  final ForgetPasswordStep step;
  final ForgetPasswordOperation operation;
  final String otp;
  final String otpToken;
  final String? email;
  final int remainingSeconds;

  ForgetPasswordState({
    this.step = ForgetPasswordStep.email,
    this.operation = ForgetPasswordOperation.none,
    this.otp = '',
    this.otpToken = '',
    this.email,
    this.remainingSeconds = 30,
    super.isLoading = false,
    super.errorMessage,
    super.data,
  });

  bool get canResend =>
      remainingSeconds == 0 && operation != ForgetPasswordOperation.resendOtp;

  @override
  ForgetPasswordState copyWith({
    ForgetPasswordStep? step,
    ForgetPasswordOperation? operation,
    String? otp,
    String? otpToken,
    String? email,
    int? remainingSeconds,
    bool? isLoading,
    Object? errorMessage = unset,
    Object? data = unset,
  }) {
    return ForgetPasswordState(
      step: step ?? this.step,
      operation: operation ?? this.operation,
      otp: otp ?? this.otp,
      otpToken: otpToken ?? this.otpToken,
      email: email ?? this.email,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
      data: identical(data, unset) ? this.data : data,
    );
  }

  @override
  List<Object?> get props => [
    step,
    operation,
    otp,
    otpToken,
    email,
    remainingSeconds,
    isLoading,
    errorMessage,
    data,
  ];
}
