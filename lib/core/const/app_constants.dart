abstract final class AppConstants {
  static const String storageTokenKey = 'userTokenKey';
  static const String rememberMeKey = 'rememberMeKey';
  static const String localeKey = 'appLocaleKey';
  static const String storageRefreshTokenKey = 'userRefreshTokenKey';
  static const String guestModeKey = 'guestModeKey';
  static const String activeOrderIdKey = 'activeOrderIdKey';
  static const String mapTilerApiKeyQueryParam = 'key';
  static const String mapTilerUrlTemplate =
      'https://api.maptiler.com/maps/dataviz-light/256/{z}/{x}/{y}.png?$mapTilerApiKeyQueryParam={$mapTilerApiKeyQueryParam}';
  static const String mapFallbackUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String appPackageName = 'com.tracking.app';
}
