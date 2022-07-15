import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/market_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsLetter extends StatefulWidget {
  String newsLetterMode;
  NewsLetter(this.newsLetterMode, {Key? key}) : super(key: key);

  @override
  State<NewsLetter> createState() => _NewsLetterState();
}

class _NewsLetterState extends State<NewsLetter> {
  String? marketName;
  String? marketCode;
  bool texterror = false;
  TextEditingController emailController = TextEditingController();
  ThemeBloc? bloc;

  @override
  void initState() {
    // TODO: implement initState

    bloc = context.read<ThemeBloc>();
    super.initState();
  }

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    marketName = prefs.getString(PrefKeys.SELECTED_MARKET) ?? 'National S.E';
    marketCode = prefs.getString(PrefKeys.SELECTED_MARKET_CODE) ?? 'in_nse';
  }

  void awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketSelection(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      marketCode = result['marketCode'];
      marketName = result['marketName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.news_letter_points_title),
      ),
      body: FutureBuilder(
        future: getListValuesSF(),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  child: Image.asset(
                    'assets/images/news_letter.PNG',
                    color: DefaultTextStyle.of(context).style.color,
                    width: 50,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    AppLocalizations.of(context)!.news_letter_points_title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(AppLocalizations.of(context)!.news_letter_points_desc),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: InkWell(
                    onTap: () {
                      awaitReturnValueFromSecondScreen(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          marketName ?? 'National S.E',
                          style: const TextStyle(
                              fontSize: 15,
                              color: Color(ColorHex.DARK_GREY),
                              fontWeight: FontWeight.bold),
                        ),
                        Transform.rotate(
                          angle: 33, //set the angel
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.orange[800],
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                    dense: true,
                    horizontalTitleGap: 0.0,
                    title: Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 0),

                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: TextField(
                          controller: emailController,
                          cursorColor: DefaultTextStyle.of(context).style.color,
                          style: TextStyle(
                              color: DefaultTextStyle.of(context).style.color,
                              fontSize: 12),
                          decoration: InputDecoration(
                            errorText: texterror
                                ? AppLocalizations.of(context)!.invalid_email
                                : null,
                            floatingLabelStyle: TextStyle(
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: bloc!.loadTheme == AppTheme.lightTheme
                                      ? Colors.grey.shade900
                                      : const Color(ColorHex.warmGrey),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            labelStyle: DefaultTextStyle.of(context).style,
                            labelText: AppLocalizations.of(context)!.email,
                          ),
                        ),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty ||
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(emailController.text)) {
                          setState(() {
                            texterror = true;
                          });
                        } else {
                          setState(() {
                            texterror = false;
                          });
                          http.Response response = await ApiRepo()
                              .newsLetterSubscription(
                                  emailController.text, "s", marketCode);
                          if (response.statusCode == 200) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(PrefKeys.newsLetterSubscriptionId,
                                emailController.text);
                            prefs.setString(
                                PrefKeys.newsLetterSubscriptionMode, "s");
                            prefs.setString(
                                PrefKeys.newsLetterSubscriptionMarket,
                                marketCode.toString());
                            Navigator.pop(context, Future.value(true));
                          } else {
                            // If the server did not return a 200 OK response,
                            // then throw an exception.
                            throw Exception('Failed to load data');
                          }
                        }
                      },
                      child: const Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF6600),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(5),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
