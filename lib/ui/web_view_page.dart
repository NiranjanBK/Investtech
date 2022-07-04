import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:investtech_app/ui/web_login_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final String uid;
  final String pwd;
  bool isLoading = true;
  bool isLoggedOut = false;
  WebViewPage(this.title, this.url, this.uid, this.pwd, {Key? key})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.

    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  void _logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(PrefKeys.pwd);
    widget.isLoggedOut = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoggedOut == true
        ? WebLoginPage(ApiRepo(), true, false)
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.grey[800]),
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
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    _webViewController.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    // color: _webViewController.canGoBack() == Future.value(true)
                    //     ? Colors.orange[800]
                    //     : Colors.grey,
                    size: 12,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _webViewController.goForward();
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 12,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.orange[800],
                    size: 14,
                  ),
                ),
                PopupMenuButton(
                    iconSize: 14,
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
                          _webViewController.loadUrl(
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
                              style: TextStyle(fontSize: 12),
                            ),
                            onTap: () {},
                          ),
                          PopupMenuItem(
                            height: 30,
                            value: 'Logout',
                            child: Text(
                              AppLocalizations.of(context)!.logout,
                              style: TextStyle(fontSize: 12),
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
            body: Stack(
              children: [
                InAppWebView(
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
                  onLoadStop: (controller, url) async {
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
              ],
            ),
          );
  }
}
