import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/disclaimer_page.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:investtech_app/ui/web_view_privacy_page.dart';
import 'package:investtech_app/widgets/pref_keys.dart';
import 'package:investtech_app/widgets/theme.dart';
import 'package:open_store/open_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  List<String>? language = [
    'English',
    'Norweign',
    'Swedish',
    'Danish',
    'German'
  ];
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

  Future<String> getUserTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PrefKeys.SELECTED_THEME) ?? 'Light';
  }

  void getAppInfo() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version = packageInfo.version;
    // print('debug $version');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
        future: getUserTheme(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Text(''),
                    title: Text(
                      'Account Settings',
                      style: TextStyle(color: Colors.orange[800], fontSize: 12),
                    ),
                  ),
                  ListTile(
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
                      'Newsletter Subscription',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    subtitle: Text(
                      'Free daily newsletter every morning!',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: Switch(
                      inactiveTrackColor: Theme.of(context).iconTheme.color,
                      onChanged: toggleSwitch,
                      value: isNewsLetterSwitched,
                      activeColor: Colors.orange[700],
                      //activeTrackColor: Colors.yellow,
                      //inactiveThumbColor: Colors.redAccent,
                      //inactiveTrackColor: Colors.orange,
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
                      'Language',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    subtitle: Text(
                      widget._groupValLang.toString(),
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
                                    lang,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  leading: Radio(
                                    activeColor: const Color(0XFF008080),
                                    value: lang,
                                    groupValue: widget._groupValLang,
                                    onChanged: (String? value) {
                                      setState(() {
                                        widget._groupValLang = value;
                                      });
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
                            child: const Text(
                              'Cancel',
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
                      'Theme',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    subtitle: Text(
                      snapshot.data.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 0),
                        title: const Text(
                          'Theme',
                          style: TextStyle(),
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
                                    groupValue: snapshot.data.toString(),
                                    onChanged: (String? value) async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          PrefKeys.SELECTED_THEME, value!);
                                      // setState(() {
                                      //   widget._groupValTheme = value;
                                      // });
                                      AppTheme selectedTheme = value == 'Dark'
                                          ? AppTheme.darkTheme
                                          : AppTheme.lightTheme;
                                      BlocProvider.of<ThemeBloc>(context).add(
                                          ThemeEvent(appTheme: selectedTheme));
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
                            child: const Text('Cancel',
                                style: TextStyle(color: Color(0xFFFF6600))),
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
                          'Sharing',
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
                          'Include notes',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        subtitle: Text(
                          'include personal notes associated with a stock while sharing',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        trailing: Switch(
                          inactiveTrackColor: Theme.of(context).iconTheme.color,
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
                          'About',
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
                            'Disclaimer',
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
                            'Privacy Policy',
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
                            'Terms & condition',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Text(''),
                        title: Text(
                          'Version',
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
                            androidAppBundleId: 'com.investtech.investtechapp',
                          );
                        },
                        child: ListTile(
                          leading: Text(''),
                          title: Text(
                            'Learn Technical Analysis',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            'Get the app',
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
                            'Help',
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
                              'Chart Explanation',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            subtitle: Text(
                              'Understand our charts',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Text(''),
                          title: Text(
                            'Support',
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
    );
  }
}
