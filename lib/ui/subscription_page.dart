import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/ui/top20_advancedChart_subscription_page.dart';
import 'package:investtech_app/ui/web_login_page.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context)!.subscriptions,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (BuildContext context) => SearchBloc(ApiRepo()),
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
            onPressed: () {},
            icon: Icon(
              Icons.refresh,
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
                        builder: (context) => SettingsPage(),
                      ));
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                height: 30,
                value: 'Manage',
                child: Text(
                  'Manage',
                  style: TextStyle(fontSize: 12),
                ),
              ),
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
      body: Column(
        children: [
          Container(
            color: const Color(ColorHex.subscription_header),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Center(
              child: Column(children: [
                Image.asset(
                  'assets/images/ic_unlock_icon_64dp.png',
                  width: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    AppLocalizations.of(context)!
                        .unlock_all_features
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Color(ColorHex.white),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {},
                    child: Text(
                      AppLocalizations.of(context)!
                          .free_trail_button_text
                          .toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(ColorHex.white)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color(ColorHex.ACCENT_COLOR))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ic_badge_icon.png',
                        width: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .best_value
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 9, color: Color(ColorHex.white)),
                            ),
                            Text(
                                AppLocalizations.of(context)!
                                    .per_month_after_template,
                                style: const TextStyle(
                                    fontSize: 9, color: Color(ColorHex.white)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.auto_renew_message,
                  style: const TextStyle(
                      fontSize: 9, color: Color(ColorHex.paleWhite)),
                )
              ]),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Top20AdvanceChartSubscription(
                              AppLocalizations.of(context)!.top20, true),
                        ));
                  },
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.top20,
                      style: const TextStyle(
                          color: Color(ColorHex.darkGrey),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!.top20_store_desc_short,
                      style: const TextStyle(
                        color: Color(ColorHex.darkGrey),
                        fontSize: 10,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('\$120.00',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(ColorHex.darkGrey),
                                )),
                            Text(
                              AppLocalizations.of(context)!.per_month,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(ColorHex.darkGrey),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(ColorHex.darkGrey),
                          ),
                        )
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(ColorHex.subscription_grey)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color(ColorHex.ACCENT_COLOR))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Top20AdvanceChartSubscription(
                              AppLocalizations.of(context)!.advanced_charts,
                              false),
                        ));
                  },
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.advanced_charts,
                      style: const TextStyle(
                          color: Color(ColorHex.darkGrey),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!
                          .advanced_charts_store_desc_short,
                      style: const TextStyle(
                        color: Color(ColorHex.darkGrey),
                        fontSize: 10,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('\$600.00',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(ColorHex.darkGrey),
                                )),
                            Text(
                              AppLocalizations.of(context)!.per_month,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(ColorHex.darkGrey),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(ColorHex.darkGrey),
                          ),
                        )
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(ColorHex.subscription_orange)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color(ColorHex.ACCENT_COLOR))),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebLoginPage(ApiRepo(), true, true),
                    ));
              },
              child: Text(
                AppLocalizations.of(context)!.already_a_web_subscriber,
                style: const TextStyle(
                    color: Color(ColorHex.ACCENT_COLOR), fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
