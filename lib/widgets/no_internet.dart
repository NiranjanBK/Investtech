import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/error_cloud_128dp.png',
          color: const Color(ColorHex.gray),
        ),
        Text(
          AppLocalizations.of(context)!.no_internet,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ));
  }
}
