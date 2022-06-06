import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/disclaimer_page.dart';
import 'package:investtech_app/ui/news_letter_page.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:investtech_app/ui/web_view_privacy_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:open_store/open_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  List<Map<String, String>>? language = [
    {'language': 'English', 'code': 'en'},
    {'language': 'Norweign', 'code': 'no'},
    {'language': 'Swedish', 'code': 'sv'},
    {'language': 'Danish', 'code': 'da'},
    {'language': 'German', 'code': 'de'},
  ];

  Map<String, String>? languageCodeMap = {
    'en': 'English',
    'no': 'Norweign',
    'sv': 'Swedish',
    'da': 'Danish',
    'de': 'German'
  };

  List<String>? themes = ['Light', 'Dark'];
  String? _groupValLang = 'English';
  late String _groupValTheme;

  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNewsLetterSwitched = false;
  bool isNotesSwitched = false;
  String? version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAppInfo();
  }

  void toggleSwitch(bool value) {
    if (isNewsLetterSwitched == false) {
      setState(() {
        isNewsLetterSwitched = true;
        //textValue = 'Switch Button is ON';
      });
    } else {
      setState(() {
        isNewsLetterSwitched = false;
        //textValue = 'Switch Button is OFF';
      });
    }
  }

  Future<String> getSettingPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedTheme = prefs.getString(PrefKeys.SELECTED_THEME) ?? 'Light';
    String selectedLang = prefs.getString(PrefKeys.selectedLang) ?? 'en';
    String newsLetterMode =
        prefs.getString(PrefKeys.newsLetterSubscriptionMode) ?? '';
    String newsLetterSubscriptionId =
        prefs.getString(PrefKeys.newsLetterSubscriptionId) ?? '';
    String newsLetterSubscriptionMarket =
        prefs.getString(PrefKeys.newsLetterSubscriptionMarket) ?? '';
    return jsonEncode({
      'selectedTheme': selectedTheme,
      'selectedLang': selectedLang,
      'newsLetterMode': newsLetterMode,
      'newsLetterSubscriptionId': newsLetterSubscriptionId,
      'newsLetterSubscriptionMarket': newsLetterSubscriptionMarket
    });
  }

  void getAppInfo() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version = packageInfo.version;
    // print('debug $version');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: FutureBuilder(
          future: getSettingPrefs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(
                  'debug: ${jsonDecode(snapshot.data.toString())['selectedLang']}');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Text(''),
                      title: Text(
                        AppLocalizations.of(context)!.account_settings,
                        style:
                            TextStyle(color: Colors.orange[800], fontSize: 12),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (jsonDecode(
                                snapshot.data.toString())['newsLetterMode'] ==
                            "s") {
                          http.Response response = await ApiRepo()
                              .newsLetterSubscription(
                                  jsonDecode(snapshot.data.toString())[
                                      'newsLetterSubscriptionId'],
                                  "u",
                                  jsonDecode(snapshot.data.toString())[
                                      'newsLetterSubscriptionMarket']);
                          print(jsonDecode(snapshot.data.toString())[
                              'newsLetterSubscriptionMarket']);
                          if (response.statusCode == 200) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove(PrefKeys.newsLetterSubscriptionId);
                            prefs.remove(PrefKeys.newsLetterSubscriptionMode);
                            prefs.remove(PrefKeys.newsLetterSubscriptionMarket);
                            setState(() {});
                            //return Home.fromJson(jsonDecode(response.body));
                          } else {
                            throw Exception('Failed to load data');
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsLetter(
                                    jsonDecode(snapshot.data.toString())[
                                        'newsLetterMode'])),
                          ).then((value) {
                            setState(() {});
                          });
                        }
                      },
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ],
                        ),
                        title: Text(
                          AppLocalizations.of(context)!
                              .news_letter_subscription,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.news_letter_summary,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        trailing: Switch(
                          inactiveTrackColor: Theme.of(context).iconTheme.color,
                          onChanged: toggleSwitch,
                          value: jsonDecode(snapshot.data.toString())[
                                      'newsLetterMode'] ==
                                  "s"
                              ? true
                              : false,
                          activeColor: Colors.orange[700],
                          //activeTrackColor: Colors.yellow,
                          //inactiveThumbColor: Colors.redAccent,
                          //inactiveTrackColor: Colors.orange,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.language,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.language,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      subtitle: Text(
                        widget.languageCodeMap![
                                '${jsonDecode(snapshot.data.toString())['selectedLang']}']
                            .toString(),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 0),
                          title: const Text('Language'),
                          content: SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                ...widget.language!.map((lang) {
                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    title: Text(
                                      lang['language'].toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    leading: Radio(
                                      activeColor: const Color(0XFF008080),
                                      value: lang['language'].toString(),
                                      groupValue: widget.languageCodeMap![
                                              jsonDecode(snapshot.data
                                                  .toString())['selectedLang']]
                                          .toString(),
                                      onChanged: (String? value) async {
                                        print(lang['code'].toString());
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(PrefKeys.selectedLang,
                                            lang['code'].toString());
                                        // setState(() {
                                        //   widget._groupValTheme = value;
                                        // });
                                        Locale selectedLocale =
                                            Locale(lang['code'].toString());
                                        BlocProvider.of<ThemeBloc>(context)
                                          ..add(ThemeBlocEvents.localeChanged)
                                          ..locale = selectedLocale;
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(color: Color(0xFFFF6600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.color_lens,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.theme,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      subtitle: Text(
                        jsonDecode(snapshot.data.toString())['selectedTheme'],
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 0),
                          title: Text(
                            AppLocalizations.of(context)!.theme,
                            style: const TextStyle(),
                          ),
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                ...widget.themes!.map((theme) {
                                  return ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    title: Text(
                                      theme,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    leading: Radio(
                                      activeColor: const Color(0XFF008080),
                                      value: theme,
                                      groupValue:
                                          jsonDecode(snapshot.data.toString())[
                                                  'selectedTheme']
                                              .toString(),
                                      onChanged: (String? value) async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            PrefKeys.SELECTED_THEME, value!);
                                        // setState(() {
                                        //   widget._groupValTheme = value;
                                        // });
                                        AppTheme selectedTheme = value == 'Dark'
                                            ? AppTheme.darkTheme
                                            : AppTheme.lightTheme;
                                        BlocProvider.of<ThemeBloc>(context)
                                          ..add(ThemeBlocEvents.themeChamged)
                                          ..loadTheme = selectedTheme;
                                        Navigator.pop(context, 'Cancel');
                                      },
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(AppLocalizations.of(context)!.cancel,
                                  style: const TextStyle(
                                      color: Color(0xFFFF6600))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      //indent: 20,
                      // endIndent: 0,
                      color: Colors.grey[300],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Text(''),
                          title: Text(
                            AppLocalizations.of(context)!.sharing,
                            style: TextStyle(
                                color: Colors.orange[800], fontSize: 12),
                          ),
                        ),
                        ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.share,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ],
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.include_notes,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!.include_notes_summary,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          trailing: Switch(
                            inactiveTrackColor:
                                Theme.of(context).iconTheme.color,
                            onChanged: (_) {
                              if (isNotesSwitched == false) {
                                setState(() {
                                  isNotesSwitched = true;
                                  //textValue = 'Switch Button is ON';
                                });
                              } else {
                                setState(() {
                                  isNotesSwitched = false;
                                  //textValue = 'Switch Button is OFF';
                                });
                              }
                            },
                            value: isNotesSwitched,
                            activeColor: Colors.orange[700],
                            //activeTrackColor: Colors.yellow,
                            //inactiveThumbColor: Colors.redAccent,
                            //inactiveTrackColor: Colors.orange,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          //indent: 20,
                          // endIndent: 0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Text(''),
                          title: Text(
                            AppLocalizations.of(context)!.about,
                            style: TextStyle(
                                color: Colors.orange[800], fontSize: 12),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Disclaimer()),
                            );
                          },
                          child: ListTile(
                            leading: Text(''),
                            title: Text(
                              AppLocalizations.of(context)!.disclaimer,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewPrivacyPage(
                                      'Privacy Policy',
                                      'https://www.investtech.com/main/market.php?MarketID=1&product=0')),
                            );
                          },
                          child: ListTile(
                            leading: Text(''),
                            title: Text(
                              AppLocalizations.of(context)!.privacy_policy,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewPrivacyPage(
                                      'Terms & Conditions',
                                      'https://www.investtech.com/main/market.php?MarketID=441&product=44&fn=/uk/disclaimerAndTerms.phtm&lang=000')),
                            );
                          },
                          child: ListTile(
                            leading: Text(''),
                            title: Text(
                              AppLocalizations.of(context)!
                                  .terms_and_conditions,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(''),
                          title: Text(
                            AppLocalizations.of(context)!.version,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            version.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            OpenStore.instance.open(
                              //appStoreId: 'com.investtech.investtechapp',
                              androidAppBundleId:
                                  'com.investtech.investtechapp',
                            );
                          },
                          child: ListTile(
                            leading: Text(''),
                            title: Text(
                              AppLocalizations.of(context)!.lta,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)!.get_the_app,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          //indent: 20,
                          // endIndent: 0,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: const Text(''),
                            title: Text(
                              AppLocalizations.of(context)!.help,
                              style: TextStyle(
                                  color: Colors.orange[800], fontSize: 12),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewPrivacyPage(
                                        'Chart Explanation',
                                        'https://www.investtech.com/main/com/charthelp2012_000.php')),
                              );
                            },
                            child: ListTile(
                              leading: Text(''),
                              title: Text(
                                AppLocalizations.of(context)!.chart_explanation,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              subtitle: Text(
                                AppLocalizations.of(context)!
                                    .chart_explanation_summary,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(''),
                            title: Text(
                              AppLocalizations.of(context)!.support,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ]),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
