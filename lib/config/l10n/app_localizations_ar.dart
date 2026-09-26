// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get floweryriderapp => 'فلاوري رايدر';

  @override
  String get applyNow => 'قدّم الآن';

  @override
  String get welcomeTo => 'مرحباً بك في';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get verifyOtp => 'تأكيد الرمز';

  @override
  String get otp => 'رمز التحقق';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String otpSentTo(Object email) {
    return 'أدخل رمز التحقق المرسل إلى $email';
  }

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String resendOtpIn(Object seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get invalidOtp => 'يجب أن يتكون رمز التحقق من 6 أرقام';

  @override
  String get seconds => 'ثوانٍ';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmYourPassword => 'أكّد كلمة المرور';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'يجب ألا تقل كلمة المرور عن 8 أحرف';

  @override
  String get passwordMustContainUppercase =>
      'يجب أن تحتوي كلمة المرور على حرف كبير';

  @override
  String get passwordMustContainLowercase =>
      'يجب أن تحتوي كلمة المرور على حرف صغير';

  @override
  String get passwordMustContainNumber => 'يجب أن تحتوي كلمة المرور على رقم';

  @override
  String get passwordMustContainSpecialCharacter =>
      'يجب أن تحتوي كلمة المرور على رمز خاص';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordResetSuccessfully => 'تمت إعادة تعيين كلمة المرور بنجاح';

  @override
  String get productDescription => 'وصف المنتج';

  @override
  String get productIncludes => 'المنتج يشمل';

  @override
  String get productInStock => 'المنتج متوفر';

  @override
  String get productOutOfStock => 'المنتج غير متوفر';

  @override
  String get productAvailableStock => 'الكمية المتاحة من المنتج';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get loginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get loginRequiredMessage => 'يرجى تسجيل الدخول لاستخدام هذه الميزة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgetPassword => 'نسيت كلمة المرور؟';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get loginSuccessfully => 'تم تسجيل الدخول بنجاح';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgetPasswordText => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordDescription =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق (OTP).';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

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

  @override
  String get homeTab => 'الرئيسية';

  @override
  String get ordersTab => 'الطلبات';

  @override
  String get flowerOrder => 'طلب زهور';

  @override
  String get pickupAddress => 'عنوان الاستلام';

  @override
  String get userAddress => 'عنوان العميل';

  @override
  String get floweryStore => 'متجر فلاوري';

  @override
  String get accept => 'قبول';

  @override
  String get egp => 'ج.م';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get status => 'الحالة';

  @override
  String get orderId => 'رقم الطلب';

  @override
  String get statusAccepted => 'تم القبول';

  @override
  String get statusArrivedAtPickup => 'وصلت لنقطة الاستلام';

  @override
  String get statusPicked => 'تم الاستلام';

  @override
  String get statusOutForDelivery => 'جاري التوصيل';

  @override
  String get statusDelivered => 'تم التوصيل';

  @override
  String get arrivedAtPickupPoint => 'وصلت لنقطة الاستلام';

  @override
  String get orderPickedButton => 'تم الاستلام';

  @override
  String get startDeliver => 'بدء التوصيل';

  @override
  String get arrivedToUser => 'وصلت للعميل';

  @override
  String get total => 'الإجمالي';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get noAvailableOrders => 'لا توجد طلبات متاحة حالياً';

  @override
  String get orderClaimedSuccessfully => 'تم قبول الطلب بنجاح';

  @override
  String get orderStatusUpdatedSuccessfully => 'تم تحديث حالة الطلب بنجاح';

  @override
  String get callingNotSupported => 'تعذر إجراء الاتصال';

  @override
  String get whatsappNotSupported => 'تعذر فتح تطبيق واتساب';

  @override
  String get statusArrived => 'وصل';

  @override
  String get handOrderToUser => 'تسليم الطلب للعميل';

  @override
  String get waitingForConfirmation => 'في انتظار تأكيد العميل';
}
