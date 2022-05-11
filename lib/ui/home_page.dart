import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/market_selection_page.dart';
import 'package:investtech_app/ui/reorder_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:investtech_app/widgets/barometer.dart';
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
  String marketCode = 'in_bse';
  String marketName = 'National S.E';

  Map teaser = {};

  Future<Home> fetchData() async {
    http.Response response = await ApiRepo().getHomePgae(marketCode);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      reorderString = await getListValuesSF();
      return Home.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<String> getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    //prefs.clear();
    String prefList = prefs.getString('items') ?? '';
    return prefList;
  }

  @override
  Widget build(BuildContext context) {
    late List<Teaser> teaserList = [];
    Teaser favourites = Teaser(
        '7', 'favourites', 'Favourites', {'message': 'no favourites added'});

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
        marketName = result['market'];
      });
    }

    FutureOr onGoBack(dynamic value) {
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            awaitReturnValueFromSecondScreen(context);
          },
          child: Row(
            children: [
              Text(marketName),
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
                      create: (BuildContext context) => SearchBloc(ApiRepo()),
                      child: SearchItemPage(context),
                    );
                  },
                ));
              },
              icon: const Icon(Icons.search)),
          //const Icon(Icons.search),
          PopupMenuButton(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                    break;
                }
              },
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      height: 30,
                      value: 'Reorder',
                      child: const Text(
                        'Reorder',
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {},
                    ),
                    const PopupMenuItem(
                      height: 30,
                      value: 'Settings',
                      child: Text(
                        'Settings',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ])
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5),
        child: FutureBuilder<Home>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              teaserList = snapshot.data!.teaser;
              teaserList.add(favourites);
              List reoderList =
                  reorderString == '' ? [] : reorderString.split(',');
              // reoderList.map((prodId) {
              //   snapshot.data!.teaser.map((product) {
              //     if (prodId == product.id) {
              //       teaserList.add(product);
              //     }
              //   }).toList();
              // }).toList();

              return ListView(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black12, width: 0.1))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis: ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.analysesDate) * 1000))}',
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Last Updated : Just Now',
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
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
                            margin: const EdgeInsets.only(bottom: 1),
                            //padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey[50],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 1.5,
                                  ),
                                ],
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
