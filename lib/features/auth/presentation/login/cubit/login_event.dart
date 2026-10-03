import 'package:tracking_app/core/errors/app_failure.dart';

sealed class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class RememberMeChanged extends LoginEvent {
  final bool value;

  RememberMeChanged(this.value);
}

class FormValidityChanged extends LoginEvent {
  final bool isValid;

  FormValidityChanged(this.isValid);
}

sealed class LoginUIEvent {}

class ShowMessage extends LoginUIEvent {
  final String message;
  final AppFailure? failure;

  ShowMessage(this.message, {this.failure});
}

class LoginSuccessMessage extends LoginUIEvent {}

class LoginSuccess extends LoginUIEvent {}

// class GuestLoginSuccess extends LoginUIEvent {}
