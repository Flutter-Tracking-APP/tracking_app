// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

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
  String get generalValidationError => 'إدخال غير صالح';

  @override
  String get emptyValidationError => 'هذا الحقل مطلوب';

  @override
  String get generalErrorMessage =>
      'حدث خطأ ما. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get connectionErrorMessage =>
      'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مجدداً.';

  @override
  String get noConnectionErrorMessage =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك والمحاولة مجدداً.';

  @override
  String get securityErrorMessage => 'خطأ أمني. يرجى المحاولة لاحقاً.';

  @override
  String get cancelErrorMessage => 'تم إلغاء الطلب.';

  @override
  String get code400Message =>
      'معلومات غير صالحة. يرجى التحقق من بياناتك والمحاولة مجدداً.';

  @override
  String get code401Message =>
      'انتهت صلاحية الجلسة أو بيانات الاعتماد غير صالحة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get code403Message => 'ليس لديك إذن لتنفيذ هذا الإجراء.';

  @override
  String get code404Message =>
      'المورد المطلوب غير موجود. يرجى المحاولة لاحقاً.';

  @override
  String get code409Message =>
      'هذا الحساب موجود بالفعل. حاول تسجيل الدخول بدلاً من ذلك.';

  @override
  String get code422Message => 'يرجى التحقق من معلوماتك والمحاولة مجدداً.';

  @override
  String get code429Message =>
      'محاولات كثيرة جداً. يرجى الانتظار لحظة والمحاولة مجدداً.';

  @override
  String get code500sMessage =>
      'الخادم غير متاح مؤقتاً. يرجى المحاولة بعد قليل.';

  @override
  String get addressNotFoundMessage =>
      'تعذر العثور على عنوان محدد لهذا الموقع. يرجى إدخاله يدوياً.';

  @override
  String get applyTitle => 'التقديم';

  @override
  String get applyWelcomeTitle => 'أهلاً بك!!';

  @override
  String get applyWelcomeSubtitle =>
      'هل تريد أن تصبح مندوب توصيل؟\nانضم إلى فريقنا';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get countryEgypt => 'مصر';

  @override
  String get firstNameLabel => 'الاسم الأول القانوني';

  @override
  String get firstNameHint => 'أدخل الاسم الأول القانوني';

  @override
  String get lastNameLabel => 'الاسم الثاني القانوني';

  @override
  String get lastNameHint => 'أدخل الاسم الثاني القانوني';

  @override
  String get vehicleTypeLabel => 'نوع المركبة';

  @override
  String get vehicleTypeSelectHint => 'اختر نوع المركبة';

  @override
  String get vehicleNumberLabel => 'رقم المركبة';

  @override
  String get vehicleNumberHint => 'أدخل رقم المركبة';

  @override
  String get vehicleLicenseLabel => 'رخصة المركبة';

  @override
  String get vehicleLicenseHint => 'ارفع صورة الرخصة';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => 'أدخل رقم الهاتف';

  @override
  String get nidLabel => 'الرقم القومي';

  @override
  String get nidHint => 'أدخل الرقم القومي';

  @override
  String get nidImageLabel => 'صورة بطاقة الرقم القومي';

  @override
  String get nidImageHint => 'ارفع صورة البطاقة';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أكد كلمة المرور';

  @override
  String get genderLabel => 'النوع';

  @override
  String get genderFemale => 'أنثى';

  @override
  String get genderMale => 'ذكر';

  @override
  String get continueButton => 'متابعة';

  @override
  String get successApplyHeadline => 'تم إرسال طلبك بنجاح!';

  @override
  String get successApplyBody =>
      'شكراً لتقديم طلبك، سنقوم بمراجعة طلبك والتواصل معك قريباً.';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get invalidEmailError => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get invalidPhoneError => 'يرجى إدخال رقم هاتف مصري صالح';

  @override
  String get passwordMismatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get weakPasswordError =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل تحتوي على أحرف كبيرة وصغيرة ورقم ورمز خاص';

  @override
  String get nationalIdError => 'يرجى إدخال رقم قومي صالح مكون من 14 رقماً';

  @override
  String get licenseImageRequiredError => 'يرجى رفع صورة رخصة المركبة';

  @override
  String get nidImageRequiredError => 'يرجى رفع صورة بطاقة الرقم القومي';

  @override
  String get vehicleTypeRequiredError => 'يرجى اختيار نوع المركبة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editVehicleInfoTitle => 'تعديل بيانات المركبة';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changeLanguageTitle => 'تغيير اللغة';

  @override
  String get vehicleInfoLabel => 'بيانات المركبة';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get logoutLabel => 'تسجيل الخروج';

  @override
  String get logoutDialogTitle => 'تسجيل الخروج';

  @override
  String get logoutDialogContent => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get updateButton => 'تحديث';

  @override
  String get changeButton => 'تغيير';

  @override
  String get currentPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get currentPasswordHint => 'أدخل كلمة المرور الحالية';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get confirmNewPasswordHint => 'تأكيد كلمة المرور الجديدة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get vehicleUpdatedSuccess => 'تم تحديث بيانات المركبة بنجاح';

  @override
  String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح';
}
