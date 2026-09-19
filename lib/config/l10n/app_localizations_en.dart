// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get floweryriderapp => 'Flowery rider app';

  @override
  String get applyNow => 'Apply now';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get otp => 'OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String otpSentTo(Object email) {
    return 'Enter the OTP sent to $email';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendOtpIn(Object seconds) {
    return 'Resend OTP in $seconds seconds';
  }

  @override
  String get invalidOtp => 'OTP must contain 6 digits';

  @override
  String get seconds => 'seconds';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get passwordMustContainUppercase =>
      'Password must contain an uppercase letter';

  @override
  String get passwordMustContainLowercase =>
      'Password must contain a lowercase letter';

  @override
  String get passwordMustContainNumber => 'Password must contain a number';

  @override
  String get passwordMustContainSpecialCharacter =>
      'Password must contain a special character';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordResetSuccessfully => 'Password reset successfully';

  @override
  String get productDescription => 'Description';

  @override
  String get productIncludes => 'Includes';

  @override
  String get productInStock => 'In Stock';

  @override
  String get productOutOfStock => 'Out of Stock';

  @override
  String get productAvailableStock => 'Available Stock';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign up';

  @override
  String get loginRequired => 'Login required';

  @override
  String get loginRequiredMessage => 'Please login to use this feature.';

  @override
  String get cancel => 'Cancel';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgetPassword => 'Forget Password?';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get dontHaveAccount => 'Don\'t have account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get loginSuccessfully => 'Login Successfully';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgetPasswordText => 'Forgot Password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we will send you an OTP.';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get invalidEmail => 'Please enter a valid email';

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
