import 'package:flutter/widgets.dart';
import 'package:tracking_app/core/errors/app_failure.dart';
import 'package:tracking_app/core/ui/handlers/app_error_handler.dart';

extension AppFailureLocalization on AppFailure {
  String toLocalizedMessage(BuildContext context) {
    return switch (this) {
      ServerMessageFailure(:final message) => message,
      NetworkFailure(:final error) =>
        AppErrorHandler.getLocalizedMessage(context, error),
    };
  }
}
