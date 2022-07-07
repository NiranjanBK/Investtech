import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hidable/hidable.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/internet/connection_status.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/ui/home_page.dart';
import 'package:investtech_app/ui/intro_page.dart';
import 'package:investtech_app/ui/subscription_page.dart';
import 'package:investtech_app/ui/web_login_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

var analysisDate;
var globalMarketId;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get any initial links
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  print(WidgetsBinding.instance.window.locale.countryCode);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('items');
  String? prefTheme = prefs.getString(PrefKeys.SELECTED_THEME) ?? '';
  String? locale = prefs.getString(PrefKeys.selectedLang) ?? 'en';
  bool? introSlides = prefs.getBool(PrefKeys.introSlides) ?? false;
  globalMarketId = prefs.getString(PrefKeys.SELECTED_MARKET_ID) ?? '911';

  if (prefs.getString(PrefKeys.SELECTED_MARKET) == null) {
    String countryCode = WidgetsBinding.instance.window.locale.countryCode
        .toString()
        .toLowerCase();
    await DatabaseHelper().setUserMarketPref(countryCode);
    print(countryCode);
  }

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
  runApp(MyApp(prefTheme, locale, introSlides, initialLink));
}

class MyApp extends StatelessWidget {
  final String? prefTheme;
  final String locale;
  final bool introSlides;
  final PendingDynamicLinkData? initialLink;
  ThemeData? themeData;
  Locale? newLocale;
  MyApp(this.prefTheme, this.locale, this.introSlides, this.initialLink,
      {Key? key})
      : super(key: key);

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
            home: MainPage(introSlides, initialLink),
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final bool introSlides;
  final PendingDynamicLinkData? initialLink;
  const MainPage(this.introSlides, this.initialLink, {Key? key})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  GlobalKey<HomeOverviewState> homeKey = GlobalKey();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _onWillPop() {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  void initState() {
    widgetOptions = [
      HomeOverview(
        key: homeKey,
      ),
      WebLoginPage(ApiRepo(), false, false),
      Subscription(),
    ];
    if (widget.introSlides) {
      setLTA();
    }
    FlutterNativeSplash.remove();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print(
          'debug dynamic ${jsonDecode(jsonEncode(dynamicLinkData.link.queryParameters))['CompanyID']}');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyPage(
              jsonDecode(jsonEncode(dynamicLinkData.link.queryParameters))[
                  'CompanyID'],
              4,
            ),
          ));
      //('debug dynamic ${widget.initialLink!.link.queryParameters}');
      //print(widget.initialLink!.link.pathSegments);
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      // Handle errors
    });

    if (widget.initialLink != null) {
      final Uri deepLink = widget.initialLink!.link;
      // Example of using the dynamic link to push the user to a different screen
      //Navigator.pushNamed(context, deepLink.path);

      print('debug dynamic ${widget.initialLink!.link.queryParameters}');
      print(widget.initialLink!.link.pathSegments);
    }
    super.initState();
  }

  setLTA() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefKeys.LTA_CONTAINER, true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.introSlides
        ? IntroScreen()
        : WillPopScope(
            onWillPop: () => _onWillPop(),
            child: Scaffold(
              body: Container(
                child: widgetOptions[selectedIndex],
              ),
              bottomNavigationBar: Hidable(
                controller:
                    homeKey.currentState?.controller ?? ScrollController(),
                child: BottomNavigationBar(
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
              ),
            ),
          );
  }
}
