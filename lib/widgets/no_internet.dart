import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';

class NoInternet extends StatelessWidget {
  final String error;
  const NoInternet(this.error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('my error: $error');
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/error_cloud_128dp.png',
          color: const Color(ColorHex.gray),
        ),
        error == 'No Internet'
            ? Text(
                AppLocalizations.of(context)!.no_internet,
                style: const TextStyle(fontSize: 12),
              )
            : Text(AppLocalizations.of(context)!.unknown_error)
      ],
    ));
  }
}
