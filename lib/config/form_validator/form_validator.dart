import 'dart:io';
import 'package:tracking_app/core/utils/app_validators.dart';

export 'package:tracking_app/core/utils/app_validators.dart';

abstract final class FormValidator {
  static const String usernamePattern = AppValidators.usernamePattern;
  static const String namePattern = AppValidators.namePattern;
  static const String emailPattern = AppValidators.emailPattern;

  static const String passwordUppercasePattern =
      AppValidators.passwordUppercasePattern;
  static const String passwordLowercasePattern =
      AppValidators.passwordLowercasePattern;
  static const String passwordNumberPattern =
      AppValidators.passwordNumberPattern;
  static const String passwordSpecialCharPattern =
      AppValidators.passwordSpecialCharPattern;

  static const String phonePattern = AppValidators.phonePattern;
  static const String nationalIdPattern = AppValidators.nationalIdPattern;

  static bool validate(String pattern, String input) {
    return AppValidators.validate(pattern, input);
  }

  static PasswordValidationResult validatePassword(String input) {
    if (input.length < 8) {
      return LengthError();
    } else if (!RegExp(passwordUppercasePattern).hasMatch(input)) {
      return UppercaseError();
    } else if (!RegExp(passwordLowercasePattern).hasMatch(input)) {
      return LowercaseError();
    } else if (!RegExp(passwordNumberPattern).hasMatch(input)) {
      return NumberError();
    } else if (!RegExp(passwordSpecialCharPattern).hasMatch(input)) {
      return SpecialCharError();
    } else {
      return Valid();
    }
  }

  static String? validateRequired(String? val, String emptyMessage) {
    return AppValidators.validateRequired(val) != null ? emptyMessage : null;
  }

  static String? validateEmail(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    final res = AppValidators.validateEmail(val);
    if (res == ValidationError.empty) return emptyMessage;
    if (res == ValidationError.invalidEmail) return invalidMessage;
    return null;
  }

  static String? validatePhone(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    final res = AppValidators.validatePhone(val);
    if (res == ValidationError.empty) return emptyMessage;
    if (res == ValidationError.invalidPhone) return invalidMessage;
    return null;
  }

  static String? validateNationalId(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    final res = AppValidators.validateNationalId(val);
    if (res == ValidationError.empty) return emptyMessage;
    if (res == ValidationError.invalidNationalId) return invalidMessage;
    return null;
  }

  static String? validatePasswordValue(
    String? val,
    String emptyMessage,
    String weakMessage,
  ) {
    final res = AppValidators.validatePassword(val);
    if (res == ValidationError.empty) return emptyMessage;
    if (res == ValidationError.weakPassword) return weakMessage;
    return null;
  }

  static String? validateConfirmPassword(
    String? val,
    String passwordToMatch,
    String emptyMessage,
    String mismatchMessage,
  ) {
    final res = AppValidators.validateConfirmPassword(val, passwordToMatch);
    if (res == ValidationError.empty) return emptyMessage;
    if (res == ValidationError.passwordMismatch) return mismatchMessage;
    return null;
  }

  static String? validateFile(File? file, String requiredMessage) {
    return AppValidators.validateFile(file) != null ? requiredMessage : null;
  }

  static String? validateDropdown<T>(T? value, String requiredMessage) {
    return AppValidators.validateDropdown(value) != null
        ? requiredMessage
        : null;
  }
}

sealed class PasswordValidationResult {}

class Valid extends PasswordValidationResult {}

class LengthError extends PasswordValidationResult {}

class UppercaseError extends PasswordValidationResult {}

class LowercaseError extends PasswordValidationResult {}

class NumberError extends PasswordValidationResult {}

class SpecialCharError extends PasswordValidationResult {}
