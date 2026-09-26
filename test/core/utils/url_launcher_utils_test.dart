import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/utils/url_launcher_utils.dart';

void main() {
  group('UrlLauncherUtils', () {
    test('cleanPhoneNumber keeps digits and leading +', () {
      expect(UrlLauncherUtils.cleanPhoneNumber('+20 10 1234 5678'), equals('+201012345678'));
      expect(UrlLauncherUtils.cleanPhoneNumber('010-1234-5678'), equals('01012345678'));
      expect(UrlLauncherUtils.cleanPhoneNumber(' (011) 22334455 '), equals('01122334455'));
    });

    test('cleanWhatsAppNumber strips non-digits and prepends Egypt country code 2 if starts with 01', () {
      expect(UrlLauncherUtils.cleanWhatsAppNumber('01012345678'), equals('201012345678'));
      expect(UrlLauncherUtils.cleanWhatsAppNumber('+201012345678'), equals('201012345678'));
      expect(UrlLauncherUtils.cleanWhatsAppNumber('01122334455'), equals('201122334455'));
      expect(UrlLauncherUtils.cleanWhatsAppNumber('01299887766'), equals('201299887766'));
      expect(UrlLauncherUtils.cleanWhatsAppNumber('01511223344'), equals('201511223344'));
      expect(UrlLauncherUtils.cleanWhatsAppNumber('447123456789'), equals('447123456789'));
    });

    test('launchPhoneCall returns false when phoneNumber is null or empty', () async {
      expect(await UrlLauncherUtils.launchPhoneCall(null), isFalse);
      expect(await UrlLauncherUtils.launchPhoneCall(''), isFalse);
      expect(await UrlLauncherUtils.launchPhoneCall('   '), isFalse);
    });

    test('launchWhatsApp returns false when phoneNumber is null or empty', () async {
      expect(await UrlLauncherUtils.launchWhatsApp(null), isFalse);
      expect(await UrlLauncherUtils.launchWhatsApp(''), isFalse);
      expect(await UrlLauncherUtils.launchWhatsApp('   '), isFalse);
    });
  });
}
