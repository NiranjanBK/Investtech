import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:crypto/crypto.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/theme.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';

import 'package:investtech_app/ui/company%20search/search_item_page.dart';
import 'package:investtech_app/ui/home%20menu/settings_page.dart';
import 'package:investtech_app/ui/web/web_view_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebLoginPage extends StatefulWidget {
  ApiRepo apiRepo;
  bool isLoggedOut;
  bool isEmptyAppBarActions;
  WebLoginPage(this.apiRepo, this.isLoggedOut, this.isEmptyAppBarActions,
      {Key? key})
      : super(key: key);

  @override
  _WebLoginPageState createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  bool _passwordVisible = true;
  bool isVerifiedUser = false;
  bool isLoading = false;
  late String? uid;
  late String? pwd;
  late String countryId;
  ThemeBloc? bloc;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    bloc = context.read<ThemeBloc>();
    super.initState();
  }

  addToSF(key, value, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "string") {
      prefs.setString(key, value);
    } else {
      prefs.setBool(key, value);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 230,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: const Color(0xFF9E9E9E),
      content: Text(
        AppLocalizations.of(context)!.web_login_invalid,
        style: const TextStyle(color: Colors.white),
      ),
      //duration: Duration(seconds: 3),
    );

    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              uid = snapshot.data!.getString(PrefKeys.uid) ?? '';
              pwd = snapshot.data!.getString(PrefKeys.pwd) ?? '';
              countryId =
                  snapshot.data!.getString(PrefKeys.SELECTED_COUNTRY_ID) ??
                      '100';
              if (widget.isLoggedOut) {
                nameController.text = uid ?? '';
              }
              if (pwd != '' && uid != null) {
                isVerifiedUser = true;
              }
            }

            return isVerifiedUser == false
                ? Scaffold(
                    appBar: widget.isEmptyAppBarActions
                        ? AppBar(
                            leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                            title: Text(AppLocalizations.of(context)!.login),
                          )
                        : AppBar(
                            bottom: PreferredSize(
                                preferredSize: const Size(double.infinity, 1),
                                child: SizedBox(
                                  height: 1,
                                  child: isLoading == true
                                      ? LinearProgressIndicator(
                                          backgroundColor: Colors.white,
                                          color: Colors.orange[800],
                                        )
                                      : Container(),
                                )),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (BuildContext context) =>
                                            SearchBloc(ApiRepo()),
                                        child: SearchItemPage(context),
                                      );
                                    },
                                  ));
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.orange[800],
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
                                ),
                              ),
                              PopupMenuButton(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                onSelected: (value) {
                                  switch (value) {
                                    case 'Settings':
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsPage(),
                                          ));
                                      break;
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                    height: 30,
                                    value: 'Settings',
                                    child: Text(
                                      'Settings',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Center(
                              child: SizedBox(
                                  width: 200,
                                  height: 100,
                                  /*decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50.0)),*/
                                  child: Image.asset(
                                      'assets/images/logo_with_text.png')),
                            ),
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: TextField(
                                controller: nameController,
                                cursorColor:
                                    DefaultTextStyle.of(context).style.color,
                                //style: const TextStyle(),
                                decoration: InputDecoration(
                                  floatingLabelStyle: const TextStyle(
                                      color: Color(ColorHex.warmGrey)),
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color:
                                        bloc!.loadTheme == AppTheme.lightTheme
                                            ? Colors.grey.shade900
                                            : const Color(ColorHex.warmGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bloc!.loadTheme ==
                                                AppTheme.lightTheme
                                            ? Colors.grey.shade900
                                            : const Color(ColorHex.warmGrey),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.username,
                                  labelStyle:
                                      DefaultTextStyle.of(context).style,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            //padding: EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: TextField(
                                controller: passwordController,
                                obscureText: _passwordVisible,
                                cursorColor:
                                    DefaultTextStyle.of(context).style.color,
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                      DefaultTextStyle.of(context).style,
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color:
                                        bloc!.loadTheme == AppTheme.lightTheme
                                            ? Colors.grey.shade900
                                            : const Color(ColorHex.warmGrey),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color:
                                          bloc!.loadTheme == AppTheme.lightTheme
                                              ? Colors.grey.shade900
                                              : const Color(ColorHex.warmGrey),
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: bloc!.loadTheme ==
                                                AppTheme.lightTheme
                                            ? Colors.grey.shade900
                                            : const Color(ColorHex.warmGrey),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.password,
                                  labelStyle:
                                      DefaultTextStyle.of(context).style,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: 175,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                Response response = await widget.apiRepo.login(
                                    nameController.text,
                                    md5
                                        .convert(utf8
                                            .encode(passwordController.text))
                                        .toString());
                                if (response.statusCode == 200) {
                                  if (jsonDecode(jsonEncode(response.data)) ==
                                      1) {
                                    setState(() {
                                      uid = nameController.text;
                                      pwd = passwordController.text.toString();

                                      print('uid: ${nameController.text}');
                                      addToSF(PrefKeys.uid, uid, 'string');
                                      addToSF(PrefKeys.pwd, pwd, 'string');
                                      addToSF(
                                          PrefKeys.UNLOCK_ALL, true, 'bool');
                                      addToSF(PrefKeys.ADVANCED_CHART, true,
                                          'bool');

                                      if (widget.isEmptyAppBarActions) {
                                        Navigator.pop(context, true);
                                      } else {
                                        isVerifiedUser = true;
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  print(response.statusCode.toString());
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .login_to_investtech_com,
                                style: TextStyle(
                                    color: Colors.orange[800], fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .webview_footer_info,
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : WebViewPage(
                    '',
                    'https://www.investtech.com/main/market.php?CountryID=$countryId',
                    uid!,
                    pwd!);
          }),
    );
  }
}
