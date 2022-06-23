import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/ui/choose_theme.dart';

class Disclaimer extends StatelessWidget {
  final bool isIntroPage;
  const Disclaimer(this.isIntroPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isIntroPage
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.disclaimer),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              title: Text(AppLocalizations.of(context)!.disclaimer),
            ),
      body: isIntroPage
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.full_disclaimer),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text(AppLocalizations.of(context)!.decline),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(175, 20)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color(ColorHex.ACCENT_COLOR)),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChooseTheme(),
                              ));
                        },
                        child: Text(AppLocalizations.of(context)!.agree),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(175, 20)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.only(top: 8, bottom: 8, left: 16)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color(ColorHex.ACCENT_COLOR)),
                        ),
                      ),
                    ],
                  )
                ],
              ))
          : Container(
              padding: const EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)!.full_disclaimer),
            ),
    );
  }
}
