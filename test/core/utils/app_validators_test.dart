import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

void main() {
  group('AppValidators Tests', () {
    test('validateRequired returns empty for null or blank input', () {
      expect(AppValidators.validateRequired(null), equals(ValidationError.empty));
      expect(AppValidators.validateRequired(''), equals(ValidationError.empty));
      expect(AppValidators.validateRequired('   '), equals(ValidationError.empty));
      expect(AppValidators.validateRequired('valid'), isNull);
    });

    test('validateEmail validates correctly', () {
      expect(AppValidators.validateEmail(null), equals(ValidationError.empty));
      expect(AppValidators.validateEmail(''), equals(ValidationError.empty));
      expect(AppValidators.validateEmail('invalid'), equals(ValidationError.invalidEmail));
      expect(AppValidators.validateEmail('test@test'), equals(ValidationError.invalidEmail));
      expect(AppValidators.validateEmail('user@example.com'), isNull);
    });

    test('validatePhone validates Egyptian phone numbers', () {
      expect(AppValidators.validatePhone(null), equals(ValidationError.empty));
      expect(AppValidators.validatePhone('123'), equals(ValidationError.invalidPhone));
      expect(AppValidators.validatePhone('0101234567'), equals(ValidationError.invalidPhone)); // 10 digits
      expect(AppValidators.validatePhone('01012345678'), isNull); // 11 digits starting with 010
      expect(AppValidators.validatePhone('01112345678'), isNull); // 011
      expect(AppValidators.validatePhone('01212345678'), isNull); // 012
      expect(AppValidators.validatePhone('01512345678'), isNull); // 015
    });

    test('validateNationalId validates 14 digits', () {
      expect(AppValidators.validateNationalId(null), equals(ValidationError.empty));
      expect(AppValidators.validateNationalId('123'), equals(ValidationError.invalidNationalId));
      expect(AppValidators.validateNationalId('123456789012345'), equals(ValidationError.invalidNationalId)); // 15
      expect(AppValidators.validateNationalId('12345678901234'), isNull); // 14
    });

    test('validatePassword validates complexity', () {
      expect(AppValidators.validatePassword(null), equals(ValidationError.empty));
      expect(AppValidators.validatePassword('short'), equals(ValidationError.weakPassword));
      expect(AppValidators.validatePassword('nouppercase1!'), equals(ValidationError.weakPassword));
      expect(AppValidators.validatePassword('NOLOWERCASE1!'), equals(ValidationError.weakPassword));
      expect(AppValidators.validatePassword('NoNumberSpecial!'), equals(ValidationError.weakPassword));
      expect(AppValidators.validatePassword('NoSpecial1234'), equals(ValidationError.weakPassword));
      expect(AppValidators.validatePassword('P@ssw0rd123'), isNull);
    });

    test('validateConfirmPassword validates match', () {
      expect(AppValidators.validateConfirmPassword(null, 'P@ssw0rd123'), equals(ValidationError.empty));
      expect(AppValidators.validateConfirmPassword('', 'P@ssw0rd123'), equals(ValidationError.empty));
      expect(AppValidators.validateConfirmPassword('Mismatch', 'P@ssw0rd123'), equals(ValidationError.passwordMismatch));
      expect(AppValidators.validateConfirmPassword('P@ssw0rd123', 'P@ssw0rd123'), isNull);
    });

    test('validateFile validates null file', () {
      expect(AppValidators.validateFile(null), equals(ValidationError.fileRequired));
      expect(AppValidators.validateFile(File('path')), isNull);
    });

    test('validateDropdown validates null value', () {
      expect(AppValidators.validateDropdown(null), equals(ValidationError.dropdownRequired));
      expect(AppValidators.validateDropdown('Option 1'), isNull);
    });
  });
}
