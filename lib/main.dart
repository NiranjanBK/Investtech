import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/subscription_page.dart';
import 'package:investtech_app/ui/web_login_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './UI/home_page.dart';

var analysisDate;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? prefTheme = prefs.getString(PrefKeys.SELECTED_THEME) ?? '';
  String? locale = prefs.getString(PrefKeys.selectedLang) ?? 'en';
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      );
    }
  }
  runApp(MyApp(prefTheme, locale));
}

class MyApp extends StatelessWidget {
  final String? prefTheme;
  final String locale;
  ThemeData? themeData;
  Locale? newLocale;
  MyApp(this.prefTheme, this.locale, {Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    newLocale = Locale(locale);

    AppTheme loadTheme =
        prefTheme == 'Dark' ? AppTheme.darkTheme : AppTheme.lightTheme;
    return BlocProvider(
      create: (context) => ThemeBloc(
        loadTheme,
        Locale(locale),
      )..add(ThemeBlocEvents.themeChamged),
      child: BlocBuilder<ThemeBloc, ThemeBlocState>(
        builder: (BuildContext context, ThemeBlocState themeState) {
          if (themeState is ThemeLoadedState) {
            themeData = themeState.themeData;
            BlocProvider.of<ThemeBloc>(context).add(ThemeBlocEvents.clearState);
          }
          if (themeState is LocaleChangedState) {
            newLocale = themeState.locale;
            BlocProvider.of<ThemeBloc>(context).add(ThemeBlocEvents.clearState);
          }
          return MaterialApp(
            title: _title,
            //theme: _light ? _lightTheme : _darkTheme,
            theme: themeData,
            locale: newLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('no', ''), // Norweign, no country code
              Locale('sv', ''), // Norweign, no country code
              Locale('da', ''), // Norweign, no country code
              Locale('de', ''), // Norweign, no country code
            ],
            home: MyStatefulWidget(),
          );
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeOverview(),
    WebLoginPage(ApiRepo(), false),
    Subscription(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web_asset_off),
            label: 'Web',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_open_rounded),
            label: 'Subscription',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
