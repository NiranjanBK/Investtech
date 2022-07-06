import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseTheme extends StatefulWidget {
  int? isActive = 0;
  String imgaeName = 'theme_screenshot_light';
  Color imageBgColor = Colors.white;
  Color textBgolor = Colors.white;
  Color textColor = Color(ColorHex.GREY);
  ChooseTheme({Key? key}) : super(key: key);

  @override
  State<ChooseTheme> createState() => _ChooseThemeState();
}

class _ChooseThemeState extends State<ChooseTheme> {
  getButtonStyle(isActive) {
    if (isActive == widget.isActive) {
      return ButtonStyle(
        // fixedSize:
        //     MaterialStateProperty.all<Size>(const Size(175, 20)),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color(ColorHex.ACCENT_COLOR)),
        foregroundColor:
            MaterialStateProperty.all<Color>(const Color(ColorHex.white)),
      );
    } else {
      return ButtonStyle(
        // fixedSize:
        //     MaterialStateProperty.all<Size>(const Size(175, 20)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(
            const Color(ColorHex.ACCENT_COLOR)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.choose_a_theme,
          style: TextStyle(color: widget.textColor),
        ),
        backgroundColor: widget.textBgolor,
      ),
      body: Column(
        children: [
          Container(
            height: 400,
            width: 500,
            color: widget.imageBgColor,
            padding: const EdgeInsets.only(top: 30, left: 10, right: 20),
            child: Image.asset(
              'assets/images/${widget.imgaeName}.png',
            ),
          ),
          Expanded(
            child: Container(
              color: widget.textBgolor,
              padding: const EdgeInsets.only(top: 25, left: 10, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.isActive = 0;
                              widget.imgaeName = 'theme_screenshot_light';
                              widget.imageBgColor =
                                  const Color(ColorHex.PRIMARY_COLOR);
                              widget.textBgolor =
                                  const Color(ColorHex.PRIMARY_COLOR);
                              widget.textColor = const Color(ColorHex.GREY);
                            });
                          },
                          child: Text(AppLocalizations.of(context)!.light),
                          style: getButtonStyle(0)),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.isActive = 1;
                            widget.imgaeName = 'theme_screenshot_dark';
                            widget.imageBgColor = const Color(ColorHex.black);
                            widget.textBgolor =
                                const Color(ColorHex.darkColorPrimaryDark);
                            widget.textColor = const Color(ColorHex.white);
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.dark),
                        style: getButtonStyle(1),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      AppLocalizations.of(context)!.theme_description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: widget.textColor),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var selectedTheme;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        if (widget.isActive == 1) {
                          prefs.setString(PrefKeys.SELECTED_THEME, 'Dark');
                          selectedTheme = 'Dark';
                        } else {
                          prefs.setString(PrefKeys.SELECTED_THEME, 'Light');
                          selectedTheme = 'Light';
                        }
                        PendingDynamicLinkData? initialLink =
                            await FirebaseDynamicLinks.instance
                                .getInitialLink();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainPage(false, initialLink),
                            ));
                        AppTheme selectedAppTheme = selectedTheme == 'Dark'
                            ? AppTheme.darkTheme
                            : AppTheme.lightTheme;
                        BlocProvider.of<ThemeBloc>(context)
                          ..add(ThemeBlocEvents.themeChamged)
                          ..loadTheme = selectedAppTheme;
                      },
                      child: const Icon(Icons.arrow_forward_outlined),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(ColorHex.ACCENT_COLOR)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
