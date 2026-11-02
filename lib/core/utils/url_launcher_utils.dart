import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

abstract final class UrlLauncherUtils {
  static String cleanPhoneNumber(String number) =>
      number.replaceAll(RegExp(r'[^0-9+]'), '');

  static String cleanWhatsAppNumber(String number) {
    var clean = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.startsWith('01') && clean.length == 11) {
      clean = '2$clean';
    }
    return clean;
  }

  static Future<bool> launchPhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) return false;
    final clean = cleanPhoneNumber(phoneNumber);
    final uri = Uri(scheme: 'tel', path: clean);
    try {
      return await launchUrl(uri);
    } catch (e, stack) {
      log('UrlLauncherUtils phone call error: $e', stackTrace: stack);
      return false;
    }
  }

  static Future<bool> launchWhatsApp(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) return false;
    final clean = cleanWhatsAppNumber(phoneNumber);
    final webUri = Uri.parse('https://wa.me/$clean');
    if (await _tryLaunchUri(webUri, mode: LaunchMode.externalApplication)) {
      return true;
    }
    final appUri = Uri.parse('whatsapp://send?phone=$clean');
    return _tryLaunchUri(appUri);
  }

  static Future<bool> _tryLaunchUri(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      return await launchUrl(uri, mode: mode);
    } catch (e, stack) {
      log('UrlLauncherUtils launch error for $uri: $e', stackTrace: stack);
      return false;
    }
  }
}
