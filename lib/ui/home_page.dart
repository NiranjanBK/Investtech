import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:investtech_app/const/text_style.dart';

import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/market_selection_page.dart';
import 'package:investtech_app/ui/reorder_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:investtech_app/widgets/barometer.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/widgets/web_tv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todays_signals.dart';

import '../network/api_repo.dart';
import '../network/models/home.dart';
import '../widgets/market_commentary.dart';
import '../widgets/product_Item_Header.dart';
import '../widgets/top20.dart';
import '../widgets/indices.dart';
import '../widgets/todays_candidate.dart';
import '../widgets/indices_evaluation.dart';

class HomeOverview extends StatefulWidget {
  @override
  State<HomeOverview> createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  late String reorderString;
  String? marketCode;
  String? marketName;

  Map teaser = {};

  @override
  void initState() {
    super.initState();
    //getListValuesSF();
  }

  Future<Home> fetchData() async {
    await getListValuesSF();
    http.Response response = await ApiRepo().getHomePgae(marketCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      //reorderString = await getListValuesSF();
      return Home.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
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

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reorderString = prefs.getString('items') ?? '';
    marketName = prefs.getString(PrefKeys.SELECTED_MARKET) ?? 'National S.E';
    marketCode = prefs.getString(PrefKeys.SELECTED_MARKET_CODE) ?? 'in_nse';
  }

  @override
  Widget build(BuildContext context) {
    late List<Teaser> teaserList = [];
    Teaser favourites = Teaser(
        '7', 'favourites', 'Favourites', {'message': 'no favourites added'});

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: FutureBuilder<Home>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            teaserList = snapshot.data!.teaser;
            teaserList.add(favourites);
            List reoderList =
                reorderString == '' ? [] : reorderString.split(',');
            return Scaffold(
              appBar: AppBar(
                title: InkWell(
                  onTap: () {
                    awaitReturnValueFromSecondScreen(context);
                  },
                  child: Row(
                    children: [
                      Text(marketName ?? 'National S.E'),
                      Transform.rotate(
                        angle: 33, //set the angel
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                ),
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
                      )),
                  PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      onSelected: (value) {
                        switch (value) {
                          case 'Reorder':
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReorderPage(teaserList, reorderString),
                                )).then(onGoBack);
                            break;
                          case 'Settings':
                            var result = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                )).then((value) {
                              setState(() {});
                            });

                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                            PopupMenuItem(
                              height: 30,
                              value: 'Reorder',
                              child: Text(
                                'Reorder',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color),
                              ),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              height: 30,
                              value: 'Settings',
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .color),
                              ),
                            ),
                          ])
                ],
              ),
              body: ListView(
                primary: true,
                shrinkWrap: true,
                children: [
                  Container(
                    //height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    //color: Theme.of(context).primaryColorDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .analysis_home_header_template(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(snapshot.data!.analysesDate) *
                                          1000)),
                          style: getSmallestTextStyle(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Last Updated : ',
                              style: getSmallestTextStyle(),
                            ),
                            Text(
                              'just Now',
                              style: getSmallestTextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: reoderList.length == 0
                        ? snapshot.data!.teaser.length
                        : reoderList.length,
                    itemBuilder: (context, index) {
                      int prodId = reoderList.length == 0
                          ? index
                          : int.parse(reoderList[index]);
                      var productName =
                          snapshot.data!.teaser[index].productName +
                              '\n\n' +
                              //snapshot.data!.teaser[index].content +
                              '\n\n';
                      return Column(
                        //height: 400,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: 1,
                            ),
                            //padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: const Border(
                                    bottom: BorderSide(
                                  width: 0.8,
                                  color: Colors.black12,
                                ))),
                            child: Row(
                              children: [
                                if (snapshot.data!.teaser[prodId].productName ==
                                    'marketCommentary') ...{
                                  MarketCommentaries(
                                    snapshot.data!.teaser[prodId],
                                  ),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'todaysSignals') ...{
                                  TodaysSignals(
                                    snapshot.data!.teaser[prodId],
                                  ),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'top20') ...{
                                  TopTwenty(
                                    snapshot.data!.teaser[prodId],
                                  ),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'indicesAnalyses') ...{
                                  Indices(
                                    snapshot.data!.teaser[prodId],
                                    'analyses',
                                  ),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'todaysCandidate') ...{
                                  TodaysCandidate(
                                    snapshot.data!.teaser[prodId],
                                    'case',
                                  ),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'indicesEvaluations') ...{
                                  IndicesEvaluation(
                                      snapshot.data!.teaser[prodId]),
                                } else if (snapshot
                                        .data!.teaser[prodId].productName ==
                                    'barometer') ...{
                                  BarometerGraph(
                                      snapshot.data!.teaser[prodId].content,
                                      snapshot.data!.teaser[prodId].title),
                                } else if (snapshot
                                        .data!.teaser[7].productName ==
                                    'webTV') ...{
                                  WebTVTeaser(snapshot.data!.teaser[7]),
                                } else ...{
                                  Column(children: [
                                    Text(productName),
                                    ProductHeader('Favourites', 0),
                                  ]),
                                },

                                //Text(),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
