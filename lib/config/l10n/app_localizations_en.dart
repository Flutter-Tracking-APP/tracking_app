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

  @override
  String get applyTitle => 'Apply';

  @override
  String get applyWelcomeTitle => 'Welcome!!';

  @override
  String get applyWelcomeSubtitle =>
      'You want to be a delivery man?\nJoin our team';

  @override
  String get countryLabel => 'Country';

  @override
  String get countryEgypt => 'Egypt';

  @override
  String get firstNameLabel => 'First legal name';

  @override
  String get firstNameHint => 'Enter first legal name';

  @override
  String get lastNameLabel => 'Second legal name';

  @override
  String get lastNameHint => 'Enter second legal name';

  @override
  String get vehicleTypeLabel => 'Vehicle type';

  @override
  String get vehicleTypeSelectHint => 'Select vehicle type';

  @override
  String get vehicleNumberLabel => 'Vehicle number';

  @override
  String get vehicleNumberHint => 'Enter vehicle number';

  @override
  String get vehicleLicenseLabel => 'Vehicle license';

  @override
  String get vehicleLicenseHint => 'Upload license photo';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter you email';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => 'Enter phone number';

  @override
  String get nidLabel => 'ID number';

  @override
  String get nidHint => 'Enter national ID number';

  @override
  String get nidImageLabel => 'ID image';

  @override
  String get nidImageHint => 'Upload ID image';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get continueButton => 'Continue';

  @override
  String get successApplyHeadline => 'Your application has been submitted!';

  @override
  String get successApplyBody =>
      'Thank you for providing your application, we will review your application and will get back to you soon.';

  @override
  String get loginButton => 'Login';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get invalidPhoneError => 'Please enter a valid Egyptian phone number';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get weakPasswordError =>
      'Password must be at least 8 characters with uppercase, lowercase, number and special character';

  @override
  String get nationalIdError => 'Please enter a valid 14-digit national ID';

  @override
  String get licenseImageRequiredError =>
      'Please upload your vehicle license photo';

  @override
  String get nidImageRequiredError => 'Please upload your ID photo';

  @override
  String get vehicleTypeRequiredError => 'Please select a vehicle type';
}
