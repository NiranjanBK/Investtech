import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/company%20search/search_item_page.dart';
import 'package:investtech_app/ui/home%20menu/settings_page.dart';
import 'package:investtech_app/ui/web/web_login_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final String uid;
  final String pwd;
  bool isLoading = true;
  bool isLoggedOut = false;
  bool canGoBack = false;
  bool canGoForward = false;
  WebViewPage(this.title, this.url, this.uid, this.pwd, {Key? key})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.

    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  void _logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefKeys.pwd);
    prefs.remove(PrefKeys.UNLOCK_ALL);
    widget.isLoggedOut = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoggedOut == true
        ? WebLoginPage(ApiRepo(), true, false)
        : Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 1),
                  child: SizedBox(
                    height: 1,
                    child: widget.isLoading == true
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.orange[800],
                          )
                        : Container(),
                  )),
              actions: [
                IconButton(
                  onPressed: () {
                    _webViewController?.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: widget.canGoBack ? Colors.orange[800] : Colors.grey,
                    size: 14,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _webViewController?.goForward();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color:
                        widget.canGoForward ? Colors.orange[800] : Colors.grey,
                    size: 14,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIOverlays(
                        [SystemUiOverlay.bottom]);
                    if (MediaQuery.of(context).orientation ==
                        Orientation.portrait) {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                    } else {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp]);
                    }
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.orange[800],
                    size: 16,
                  ),
                ),
                PopupMenuButton(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    iconSize: 16,
                    onSelected: (value) {
                      switch (value) {
                        case 'Search':
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                create: (BuildContext context) =>
                                    SearchBloc(ApiRepo()),
                                child: SearchItemPage(context),
                              );
                            },
                          ));
                          break;
                        case 'Settings':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ));
                          break;

                        case 'Logout':
                          _webViewController?.loadUrl(
                            urlRequest: URLRequest(
                                url: Uri.parse('${widget.url}?Logout=1')),
                          );

                          //widget.isLoggedOut = true;
                          break;
                      }
                    },
                    itemBuilder: (ctx) => [
                          PopupMenuItem(
                            height: 30,
                            value: 'Search',
                            child: Text(
                              AppLocalizations.of(context)!.search,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {},
                          ),
                          PopupMenuItem(
                            height: 30,
                            value: 'Logout',
                            child: Text(
                              AppLocalizations.of(context)!.logout,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () {},
                          ),
                          PopupMenuItem(
                            height: 30,
                            value: 'Settings',
                            child: Text(
                              AppLocalizations.of(context)!.settings,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ])
              ],
              title: Text(widget.title),
            ),
            body: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.url),
                  method: 'POST',
                  body: Uint8List.fromList(utf8.encode(
                      "LOGIN=${widget.uid}&PASSWORD=${widget.pwd}&LOGIN_REQUEST=1&CHECK_LOGIN_MESSAGE=1&Submit=Login")),
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                  }),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onScrollChanged: (controller, x, y) {
                print('X pos: $x, Y pos: $y');
              },
              onLoadStop: (controller, url) async {
                widget.canGoBack = await controller.canGoBack();
                widget.canGoForward = await controller.canGoForward();

                setState(
                  () {
                    widget.isLoading = false;
                    if (url.toString().contains('Logout')) {
                      _logout();
                    }
                  },
                );
              },
            ),
          );
  }
}
