import 'package:flutter/material.dart';

import 'package:investtech_app/widgets/slide.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _pageController,
          children: [
            Slide(
                const Color(ColorHex.on_boarding_1),
                'search_white',
                AppLocalizations.of(context)!.intro_title_1,
                AppLocalizations.of(context)!.intro_desc_1,
                false),
            Slide(
                const Color(ColorHex.on_boarding_2),
                'sort_white',
                AppLocalizations.of(context)!.intro_title_2,
                AppLocalizations.of(context)!.intro_desc_2,
                false),
            Slide(
              const Color(ColorHex.on_boarding_3),
              'star_border_white',
              AppLocalizations.of(context)!.intro_title_3,
              AppLocalizations.of(context)!.intro_desc_3,
              true,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                      dotColor: Color(ColorHex.lightGrey),
                      paintStyle: PaintingStyle.stroke,
                      strokeWidth: 2,
                      activeDotColor: Color(ColorHex.ACCENT_COLOR)),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
