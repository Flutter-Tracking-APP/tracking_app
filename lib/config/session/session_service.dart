import 'package:injectable/injectable.dart';
import 'package:tracking_app/config/storage/secure_storage_service.dart';
import 'package:tracking_app/core/const/app_constants.dart';

@lazySingleton
class SessionService {
  final SecureStorageService _secureStorage;
  String? _inMemoryToken;

  SessionService(this._secureStorage);

  Future<void> setRememberMe(bool value) async {
    await _secureStorage.save(AppConstants.rememberMeKey, value.toString());
  }

  Future<bool> isRemembered() async {
    final value = await _secureStorage.get(AppConstants.rememberMeKey);

    return value == 'true';
  }



  Future<void> saveToken(String token, {bool rememberMe = false}) async {
    _inMemoryToken = token;
    if (rememberMe) {
      await _secureStorage.save(AppConstants.storageTokenKey, token);
    } else {
      await _secureStorage.delete(AppConstants.storageTokenKey);
    }
  }

  Future<String> getToken() async {
    if (_inMemoryToken?.isNotEmpty == true) {
      return _inMemoryToken!;
    }
    final storedToken = await _secureStorage.get(AppConstants.storageTokenKey);
    if (storedToken.isNotEmpty) {
      _inMemoryToken = storedToken;
    }
    return storedToken;
  }

  Future<void> clearSession() async {
    _inMemoryToken = null;
    await _secureStorage.delete(AppConstants.storageTokenKey);

    await _secureStorage.delete(AppConstants.rememberMeKey);

  }
}
