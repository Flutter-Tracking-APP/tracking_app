import 'dart:io';

enum ValidationError {
  empty,
  invalidEmail,
  invalidPhone,
  invalidNationalId,
  weakPassword,
  passwordMismatch,
  fileRequired,
  dropdownRequired,
}

abstract final class AppValidators {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^01[0125][0-9]{8}$';
  static const String nationalIdPattern = r'^\d{14}$';
  static const String usernamePattern = r'^[a-zA-Z0-9._]{3,}$';
  static const String namePattern = r'^[a-zA-Z\s]{3,}$';

  static const String passwordUppercasePattern = r'[A-Z]';
  static const String passwordLowercasePattern = r'[a-z]';
  static const String passwordNumberPattern = r'[0-9]';
  static const String passwordSpecialCharPattern = r'[#?!@$%^&*-]';

  static bool validate(String pattern, String input) {
    return RegExp(pattern).hasMatch(input);
  }

  static ValidationError? validateRequired(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    return null;
  }

  static ValidationError? validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!validate(emailPattern, val.trim())) return ValidationError.invalidEmail;
    return null;
  }

  static ValidationError? validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!validate(phonePattern, val.trim())) return ValidationError.invalidPhone;
    return null;
  }

  static ValidationError? validateNationalId(String? val) {
    if (val == null || val.trim().isEmpty) return ValidationError.empty;
    if (!validate(nationalIdPattern, val.trim())) {
      return ValidationError.invalidNationalId;
    }
    return null;
  }

  static ValidationError? validatePassword(String? val) {
    if (val == null || val.isEmpty) return ValidationError.empty;
    if (val.length < 8 ||
        !validate(passwordUppercasePattern, val) ||
        !validate(passwordLowercasePattern, val) ||
        !validate(passwordNumberPattern, val) ||
        !validate(passwordSpecialCharPattern, val)) {
      return ValidationError.weakPassword;
    }
    return null;
  }

  static ValidationError? validateConfirmPassword(
    String? val,
    String passwordToMatch,
  ) {
    if (val == null || val.isEmpty) return ValidationError.empty;
    if (val != passwordToMatch) return ValidationError.passwordMismatch;
    return null;
  }

  static ValidationError? validateFile(File? file) {
    if (file == null) return ValidationError.fileRequired;
    return null;
  }

  static ValidationError? validateDropdown<T>(T? value) {
    if (value == null) return ValidationError.dropdownRequired;
    return null;
  }
}
