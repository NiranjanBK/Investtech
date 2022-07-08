import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/home_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:investtech_app/ui/web_view_page.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      content: const Text(
        'Username/Password not valid',
        style: TextStyle(color: Colors.white),
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
              uid = snapshot.data?.getString(PrefKeys.uid) ?? '';
              pwd = snapshot.data?.getString(PrefKeys.pwd) ?? '';
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
                            iconTheme: IconThemeData(color: Colors.grey[800]),
                            backgroundColor: Colors.white,
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
                                  child: Image.network(
                                      'https://www.investtech.com/images/home2018/logo_200.png')),
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
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: Colors.grey.shade900,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade900,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.username,
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
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12),
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey.shade900,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey.shade900,
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
                                        color: Colors.grey.shade900,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.password,
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
                                http.Response response = await widget.apiRepo
                                    .login(
                                        nameController.text,
                                        md5
                                            .convert(utf8.encode(
                                                passwordController.text))
                                            .toString());
                                if (response.statusCode == 200) {
                                  if (jsonDecode(response.body) == 1) {
                                    setState(() {
                                      uid = nameController.text;
                                      pwd = passwordController.text.toString();
                                      isVerifiedUser = true;
                                      addToSF(PrefKeys.uid, uid, 'string');
                                      addToSF(PrefKeys.pwd, pwd, 'string');
                                      addToSF(PrefKeys.SUBSCRIBED_USER, true,
                                          'bool');
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
                    'https://www.investtech.com/main/market.php?CountryID=1',
                    uid!,
                    pwd!);
          }),
    );
  }
}
