import 'dart:io';

abstract final class FormValidator {
  // 3+ characters (letters, numbers, underscore, dot)
  static const String usernamePattern = r'^[a-zA-Z0-9._]{3,}$';

  // 3+ characters (letters and spaces only)
  static const String namePattern = r'^[a-zA-Z\s]{3,}$';
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // 8+ total chars, 1+ uppercase, 1+ lowercase, 1+ number, 1+ special char (#?!@$%^&*-)
  static const String passwordUppercasePattern = r'[A-Z]';
  static const String passwordLowercasePattern = r'[a-z]';
  static const String passwordNumberPattern = r'[0-9]';
  static const String passwordSpecialCharPattern = r'[#?!@$%^&*-]';

  // Egyptian Phone Number
  static const String phonePattern = r'^01[0125][0-9]{8}$';

  // 14 digits National ID
  static const String nationalIdPattern = r'^\d{14}$';

  static bool validate(String pattern, String input) {
    return RegExp(pattern).hasMatch(input);
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
    if (val == null || val.trim().isEmpty) return emptyMessage;
    return null;
  }

  static String? validateEmail(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    if (val == null || val.trim().isEmpty) return emptyMessage;
    if (!validate(emailPattern, val.trim())) return invalidMessage;
    return null;
  }

  static String? validatePhone(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    if (val == null || val.trim().isEmpty) return emptyMessage;
    if (!validate(phonePattern, val.trim())) return invalidMessage;
    return null;
  }

  static String? validateNationalId(
    String? val,
    String emptyMessage,
    String invalidMessage,
  ) {
    if (val == null || val.trim().isEmpty) return emptyMessage;
    if (!validate(nationalIdPattern, val.trim())) return invalidMessage;
    return null;
  }

  static String? validatePasswordValue(
    String? val,
    String emptyMessage,
    String weakMessage,
  ) {
    if (val == null || val.isEmpty) return emptyMessage;
    final result = validatePassword(val);
    if (result is! Valid) return weakMessage;
    return null;
  }

  static String? validateConfirmPassword(
    String? val,
    String passwordToMatch,
    String emptyMessage,
    String mismatchMessage,
  ) {
    if (val == null || val.isEmpty) return emptyMessage;
    if (val != passwordToMatch) return mismatchMessage;
    return null;
  }

  static String? validateFile(File? file, String requiredMessage) {
    if (file == null) return requiredMessage;
    return null;
  }

  static String? validateDropdown<T>(T? value, String requiredMessage) {
    if (value == null) return requiredMessage;
    return null;
  }
}

sealed class PasswordValidationResult {}

class Valid extends PasswordValidationResult {}

class LengthError extends PasswordValidationResult {}

class UppercaseError extends PasswordValidationResult {}

class LowercaseError extends PasswordValidationResult {}

class NumberError extends PasswordValidationResult {}

class SpecialCharError extends PasswordValidationResult {}
