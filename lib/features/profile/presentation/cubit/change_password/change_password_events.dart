import 'package:tracking_app/features/profile/domain/params/change_password_params.dart';

sealed class ChangePasswordEvents {
  const ChangePasswordEvents();
}

final class ToggleCurrentPasswordVisibilityEvent extends ChangePasswordEvents {
  const ToggleCurrentPasswordVisibilityEvent();
}

final class ToggleNewPasswordVisibilityEvent extends ChangePasswordEvents {
  const ToggleNewPasswordVisibilityEvent();
}

final class ToggleConfirmNewPasswordVisibilityEvent
    extends ChangePasswordEvents {
  const ToggleConfirmNewPasswordVisibilityEvent();
}

final class SubmitChangePasswordEvent extends ChangePasswordEvents {
  final ChangePasswordParams params;
  const SubmitChangePasswordEvent(this.params);
}
