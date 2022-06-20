import 'package:flutter/material.dart';

import 'package:investtech_app/widgets/slide.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Slide(
              Color(ColorHex.on_boarding_1),
              'search_white',
              AppLocalizations.of(context)!.intro_title_1,
              AppLocalizations.of(context)!.intro_desc_1),
          Slide(
              Color(ColorHex.on_boarding_2),
              'search_white',
              AppLocalizations.of(context)!.intro_title_2,
              AppLocalizations.of(context)!.intro_desc_2),
          Slide(
              Color(ColorHex.on_boarding_3),
              'search_white',
              AppLocalizations.of(context)!.intro_title_3,
              AppLocalizations.of(context)!.intro_desc_3),
        ],
      ),
    );
  }
}
