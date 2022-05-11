import 'package:flutter/material.dart';
import 'package:investtech_app/ui/disclaimer_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/web_view_privacy_page.dart';
import 'package:open_store/open_store.dart';

class SettingsPage extends StatefulWidget {
  List<String>? language = [
    'English',
    'Norweign',
    'Swedish',
    'Danish',
    'German'
  ];
  List<String>? theme = ['Light', 'Dark'];
  String? _groupValLang = 'English';
  String? _groupValTheme = 'Light';

  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNewsLetterSwitched = false;
  bool isNotesSwitched = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
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
              leading: const Icon(Icons.mail),
              title: const Text(
                'Newsletter Subscription',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: const Text(
                'Free daily newsletter every morning!',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Switch(
                onChanged: toggleSwitch,
                value: isNewsLetterSwitched,
                activeColor: Colors.orange[700],
                //activeTrackColor: Colors.yellow,
                //inactiveThumbColor: Colors.redAccent,
                //inactiveTrackColor: Colors.orange,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text(
                'Language',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                widget._groupValLang.toString(),
                style: TextStyle(fontSize: 12),
              ),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Language'),
                  content: Column(
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
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text(
                'Theme',
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                widget._groupValTheme.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Theme'),
                  content: Column(
                    children: [
                      ...widget.theme!.map((lang) {
                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0.0),
                          title: Text(
                            lang,
                            style: const TextStyle(fontSize: 12),
                          ),
                          leading: Radio(
                            value: lang,
                            groupValue: widget._groupValTheme,
                            onChanged: (String? value) {
                              setState(() {
                                widget._groupValTheme = value;
                              });
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                        );
                      })
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
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
                    style: TextStyle(color: Colors.orange[800], fontSize: 12),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text(
                    'Include notes',
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: const Text(
                    'include personal notes associated with a stock while sharing',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Switch(
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
                    style: TextStyle(color: Colors.orange[800], fontSize: 12),
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
                  child: const ListTile(
                    leading: Text(''),
                    title: Text(
                      'Disclaimer',
                      style: TextStyle(fontSize: 12),
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
                  child: const ListTile(
                    leading: Text(''),
                    title: Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 12),
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
                  child: const ListTile(
                    leading: Text(''),
                    title: Text(
                      'Terms & condition',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const ListTile(
                  leading: Text(''),
                  title: Text(
                    'Version',
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    '3.0.4.9 (3049)',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                InkWell(
                  onTap: () {
                    OpenStore.instance.open(
                      //appStoreId: 'com.investtech.investtechapp',
                      androidAppBundleId: 'com.investtech.investtechapp',
                    );
                  },
                  child: const ListTile(
                    leading: Text(''),
                    title: Text(
                      'Learn Technical Analysis',
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      'Get the app',
                      style: TextStyle(fontSize: 12),
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
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                leading: const Text(''),
                title: Text(
                  'Help',
                  style: TextStyle(color: Colors.orange[800], fontSize: 12),
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
                child: const ListTile(
                  leading: Text(''),
                  title: Text(
                    'Chart Explanation',
                    style: TextStyle(fontSize: 12),
                  ),
                  subtitle: Text('Understand our charts',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
              const ListTile(
                leading: Text(''),
                title: Text(
                  'Support',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
