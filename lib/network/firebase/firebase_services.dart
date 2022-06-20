import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sprintf/sprintf.dart';

Future<String> createDynamicLink(cmpId, companyName) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://w2gn3.app.goo.gl',
    link: Uri.parse(
        'https://www.investtech.com/main/market.php?CompanyID=$cmpId'),
    androidParameters: const AndroidParameters(
      packageName: "com.investtech.investtechapp",
    ),
  );
  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(parameters);

  return dynamicLink.shortUrl.toString();
}
