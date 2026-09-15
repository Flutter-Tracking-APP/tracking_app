import 'package:flutter/material.dart';
import 'package:tracking_app/config/l10n/app_localizations.dart';

abstract final class AppStrings {
  // API Response Messages
  static String generalErrorMessage(BuildContext context) =>
      AppLocalizations.of(context)!.generalErrorMessage;
  static String connectionErrorMessage(BuildContext context) =>
      AppLocalizations.of(context)!.connectionErrorMessage;
  static String noConnectionErrorMessage(BuildContext context) =>
      AppLocalizations.of(context)!.noConnectionErrorMessage;
  static String securityErrorMessage(BuildContext context) =>
      AppLocalizations.of(context)!.securityErrorMessage;
  static String cancelErrorMessage(BuildContext context) =>
      AppLocalizations.of(context)!.cancelErrorMessage;
  // Status Code Messages
  static String code400Message(BuildContext context) =>
      AppLocalizations.of(context)!.code400Message;

  static String code401Message(BuildContext context) =>
      AppLocalizations.of(context)!.code401Message;
  static String code403Message(BuildContext context) =>
      AppLocalizations.of(context)!.code403Message;
  static String code404Message(BuildContext context) =>
      AppLocalizations.of(context)!.code404Message;
  static String code409Message(BuildContext context) =>
      AppLocalizations.of(context)!.code409Message;
  static String code422Message(BuildContext context) =>
      AppLocalizations.of(context)!.code422Message;
  static String code429Message(BuildContext context) =>
      AppLocalizations.of(context)!.code429Message;
  static String code500sMessage(BuildContext context) =>
      AppLocalizations.of(context)!.code500sMessage;
  static String addressNotFoundMessage(BuildContext context) =>
      AppLocalizations.of(context)!.addressNotFoundMessage;
}
