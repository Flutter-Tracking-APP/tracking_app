import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';
import 'package:tracking_app/config/network/app_error.dart';


class AppErrorHandler {
  static String getLocalizedMessage(
    BuildContext context,
    AppError error,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (error) {
      case AppError.general:
        return l10n.generalErrorMessage;

      case AppError.timeout:
        return l10n.connectionErrorMessage;

      case AppError.noConnection:
        return l10n.noConnectionErrorMessage;

      case AppError.security:
        return l10n.securityErrorMessage;

      case AppError.cancelled:
        return l10n.cancelErrorMessage;

      case AppError.badRequest:
        return l10n.code400Message;

      case AppError.unauthorized:
      case AppError.forceLogin:
        return l10n.code401Message;

      case AppError.forbidden:
        return l10n.code403Message;

      case AppError.notFound:
        return l10n.code404Message;

      case AppError.conflict:
        return l10n.code409Message;

      case AppError.validation:
        return l10n.code422Message;

      case AppError.tooManyRequests:
        return l10n.code429Message;

      case AppError.server:
        return l10n.code500sMessage;

      case AppError.badResponse:
      case AppError.unknown:
        return l10n.generalErrorMessage;
    }
  }
}