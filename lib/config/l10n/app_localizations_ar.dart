// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get emailHint => 'أدخل بريدك الإلكتروني';

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
  String get passwordHint => 'أدخل كلمة المرور';

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
}
