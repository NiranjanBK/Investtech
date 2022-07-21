import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hidable/hidable.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/internet/connection_status.dart';
import 'package:investtech_app/ui/blocs/home_bloc/home_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';
import 'package:investtech_app/ui/home/home_page.dart';
import 'package:investtech_app/ui/intro/intro_page.dart';
import 'package:investtech_app/ui/subscription/subscription_page.dart';
import 'package:investtech_app/ui/web/web_login_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

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

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? prefTheme = prefs.getString(PrefKeys.SELECTED_THEME) ?? '';
  String? locale = prefs.getString(PrefKeys.selectedLang) ?? 'en';
  bool? introSlides = prefs.getBool(PrefKeys.introSlides) ?? true;
  globalMarketId = prefs.getString(PrefKeys.SELECTED_MARKET_ID) ?? '100';

  if (prefs.getString(PrefKeys.SELECTED_MARKET) == null) {
    String? countryCode;
    List validCountryCodes = [
      'no',
      'nl',
      'be',
      'dk',
      'se',
      'fi',
      'fr',
      'de',
      'uk',
      'us',
      'cur',
      'ndx',
      'in',
      'cn',
      'CDT',
      'ch',
      'pt',
      'ENXT',
      'ABN',
      'enxt',
      'abn',
      'ca'
    ];
    try {
      countryCode = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      countryCode =
          WidgetsBinding.instance.window.locale.countryCode.toString();
    } catch (e) {
      countryCode =
          WidgetsBinding.instance.window.locale.countryCode.toString();
    }
    countryCode =
        validCountryCodes.contains(countryCode.toString().toLowerCase())
            ? countryCode.toString().toLowerCase()
            : 'us';
    print(countryCode);
    await DatabaseHelper().setUserMarketPref(countryCode.toLowerCase());
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
      BlocProvider(
        create: (ctx) => HomeBloc(),
        child: HomeOverview(
          key: homeKey,
        ),
      ),
      WebLoginPage(ApiRepo(), false, false),
      const Subscription(),
    ];
    if (widget.introSlides) {
      setLTA();
    }
    FlutterNativeSplash.remove();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyPage(
              jsonDecode(jsonEncode(dynamicLinkData.link.queryParameters))[
                  'CompanyID'],
              4,
            ),
          ));
    }).onError((error) {
      // Handle errors
    });

    if (widget.initialLink != null) {
      final Uri deepLink = widget.initialLink!.link;
      // Example of using the dynamic link to push the user to a different screen
      //Navigator.pushNamed(context, deepLink.path);

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyPage(
                jsonDecode(jsonEncode(deepLink.queryParameters))['CompanyID'],
                4,
              ),
            ));
      });
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
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: AppLocalizations.of(context)!.home,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(CupertinoIcons.globe),
                      label: AppLocalizations.of(context)!.web,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.lock_open_rounded),
                      label: AppLocalizations.of(context)!.subscriptions,
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
