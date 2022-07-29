import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/ui/discalimer/disclaimer_page.dart';
import 'package:path/path.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Slide extends StatelessWidget {
  final Color backGroundColor;
  final String imageName;
  final String title;
  final String description;
  final bool lastSlide;

  const Slide(this.backGroundColor, this.imageName, this.title,
      this.description, this.lastSlide,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool(PrefKeys.introSlides, false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Disclaimer(true),
                      ));
                },
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                child: Text(
                  lastSlide
                      ? AppLocalizations.of(context)!.done.toUpperCase()
                      : AppLocalizations.of(context)!.skip.toUpperCase(),
                  style: lastSlide
                      ? const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                      : const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/$imageName.PNG',
                  width: 100,
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    description,
                    style: const TextStyle(
                        color: Color(ColorHex.body_grey), fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
