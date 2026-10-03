import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/ui/extensions/validation_error_extension.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

void main() {
  Widget buildTestContext(void Function(BuildContext context) callback,
      {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          callback(context);
          return const SizedBox();
        },
      ),
    );
  }

  group('ValidationErrorLocalization Extension Tests', () {
    testWidgets('maps all ValidationErrors to localized strings in English',
        (tester) async {
      final messages = <ValidationError, String>{};

      await tester.pumpWidget(
        buildTestContext((context) {
          for (final error in ValidationError.values) {
            messages[error] = error.toLocalizedMessage(context);
          }
        }, locale: const Locale('en')),
      );

      expect(messages[ValidationError.empty], equals('This field is required'));
      expect(messages[ValidationError.invalidEmail],
          equals('Please enter a valid email address'));
      expect(messages[ValidationError.invalidPhone],
          equals('Please enter a valid Egyptian phone number'));
      expect(messages[ValidationError.invalidNationalId],
          equals('Please enter a valid 14-digit national ID'));
      expect(messages[ValidationError.weakPassword],
          contains('Password must be at least 8 characters'));
      expect(messages[ValidationError.passwordTooShort],
          equals('Password must be at least 8 characters'));
      expect(messages[ValidationError.passwordMissingUppercase],
          equals('Password must contain an uppercase letter'));
      expect(messages[ValidationError.passwordMissingLowercase],
          equals('Password must contain a lowercase letter'));
      expect(messages[ValidationError.passwordMissingNumber],
          equals('Password must contain a number'));
      expect(messages[ValidationError.passwordMissingSpecialChar],
          equals('Password must contain a special character'));
      expect(messages[ValidationError.passwordMismatch],
          equals('Passwords do not match'));
      expect(messages[ValidationError.fileRequired],
          equals('Please upload your vehicle license photo'));
      expect(messages[ValidationError.licenseFileRequired],
          equals('Please upload your vehicle license photo'));
      expect(messages[ValidationError.nidFileRequired],
          equals('Please upload your ID photo'));
      expect(messages[ValidationError.dropdownRequired],
          equals('Please select a vehicle type'));
    });

    testWidgets('maps all ValidationErrors to localized strings in Arabic',
        (tester) async {
      final messages = <ValidationError, String>{};

      await tester.pumpWidget(
        buildTestContext((context) {
          for (final error in ValidationError.values) {
            messages[error] = error.toLocalizedMessage(context);
          }
        }, locale: const Locale('ar')),
      );

      expect(messages[ValidationError.empty], equals('هذا الحقل مطلوب'));
      expect(messages[ValidationError.invalidEmail],
          equals('يرجى إدخال بريد إلكتروني صالح'));
      expect(messages[ValidationError.invalidPhone],
          equals('يرجى إدخال رقم هاتف مصري صالح'));
      expect(messages[ValidationError.invalidNationalId],
          equals('يرجى إدخال رقم قومي صالح مكون من 14 رقماً'));
      expect(messages[ValidationError.weakPassword],
          contains('يجب أن تتكون كلمة المرور من 8 أحرف'));
      expect(messages[ValidationError.passwordTooShort],
          equals('يجب ألا تقل كلمة المرور عن 8 أحرف'));
      expect(messages[ValidationError.passwordMissingUppercase],
          equals('يجب أن تحتوي كلمة المرور على حرف كبير'));
      expect(messages[ValidationError.passwordMissingLowercase],
          equals('يجب أن تحتوي كلمة المرور على حرف صغير'));
      expect(messages[ValidationError.passwordMissingNumber],
          equals('يجب أن تحتوي كلمة المرور على رقم'));
      expect(messages[ValidationError.passwordMissingSpecialChar],
          equals('يجب أن تحتوي كلمة المرور على رمز خاص'));
      expect(messages[ValidationError.passwordMismatch],
          equals('كلمتا المرور غير متطابقتين'));
      expect(messages[ValidationError.fileRequired],
          equals('يرجى رفع صورة رخصة المركبة'));
      expect(messages[ValidationError.licenseFileRequired],
          equals('يرجى رفع صورة رخصة المركبة'));
      expect(messages[ValidationError.nidFileRequired],
          equals('يرجى رفع صورة بطاقة الرقم القومي'));
      expect(messages[ValidationError.dropdownRequired],
          equals('يرجى اختيار نوع المركبة'));
    });
  });
}
