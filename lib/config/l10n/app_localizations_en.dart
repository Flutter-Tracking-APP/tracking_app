// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generalValidationError => 'Invalid input';

  @override
  String get emptyValidationError => 'This field is required';

  @override
  String get generalErrorMessage =>
      'Something went wrong. Please try again later.';

  @override
  String get connectionErrorMessage =>
      'Connection timeout. Please check your internet connection and try again.';

  @override
  String get noConnectionErrorMessage =>
      'No internet connection. Please check your network and try again.';

  @override
  String get securityErrorMessage => 'Security error. Please try again later.';

  @override
  String get cancelErrorMessage => 'Request was cancelled.';

  @override
  String get code400Message =>
      'Invalid information. Please check your details and try again.';

  @override
  String get code401Message =>
      'Session expired or invalid credentials. Please log in again.';

  @override
  String get code403Message =>
      'You don\'t have permission to perform this action.';

  @override
  String get code404Message =>
      'Requested resource not found. Please try again later.';

  @override
  String get code409Message =>
      'This account already exists. Try logging in instead.';

  @override
  String get code422Message => 'Please check your information and try again.';

  @override
  String get code429Message =>
      'Too many attempts. Please wait a moment before trying again.';

  @override
  String get code500sMessage =>
      'Server is temporarily unavailable. Please try again in a few moments.';

  @override
  String get addressNotFoundMessage =>
      'We couldn\'t find a specific address for this location. Please try entering it manually.';
}
