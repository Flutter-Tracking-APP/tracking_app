abstract final class Endpoints {
  static const baseUrl = 'http://10.0.2.2:5000/';
  static const applyDriver = 'api/identity/drivers/apply';
  static const vehicleTypes = 'api/identity/vehicle-types';
  static const getProfile = 'api/identity/users/me';
  static const updateProfile = 'api/identity/users/profile';
  static const updateVehicle = 'api/identity/vehicles/info';
  static const changePassword = 'api/identity/users/change-password';
  static const String forgetPassword = 'api/identity/auth/forget-password';
  static const String verifyOTP = 'api/identity/auth/otp-verification';
  static const String resetPassword = 'api/identity/auth/reset-password';
}
