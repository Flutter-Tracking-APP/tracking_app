import 'package:flutter/widgets.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/core/utils/app_validators.dart';

extension ValidationErrorLocalization on ValidationError {
  String toLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ValidationError.empty => l10n.emptyValidationError,
      ValidationError.invalidEmail => l10n.invalidEmailError,
      ValidationError.invalidPhone => l10n.invalidPhoneError,
      ValidationError.invalidNationalId => l10n.nationalIdError,
      ValidationError.weakPassword => l10n.weakPasswordError,
      ValidationError.passwordMismatch => l10n.passwordMismatchError,
      ValidationError.fileRequired => l10n.licenseImageRequiredError,
      ValidationError.dropdownRequired => l10n.vehicleTypeRequiredError,
    };
  }
}
