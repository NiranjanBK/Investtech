import 'dart:async';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:open_store/open_store.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:investtech_app/const/colors.dart';

import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/main.dart';

import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/market_selection_page.dart';
import 'package:investtech_app/ui/reorder_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';
import 'package:investtech_app/widgets/barometer.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/widgets/favorites.dart';
import 'package:investtech_app/widgets/web_tv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/todays_signals.dart';

import '../network/api_repo.dart';
import '../network/models/home.dart';
import '../widgets/market_commentary.dart';

import '../widgets/top20.dart';
import '../widgets/indices.dart';
import '../widgets/todays_candidate.dart';
import '../widgets/indices_evaluation.dart';

import 'package:event/event.dart';

EventBus eventBus = EventBus(sync: true);
// final controller = StreamController<String>();

var myEvent = Event<Reload>();
var c = Counter();

class ReloadEvent {}

// An example custom 'argument' class
class Reload extends EventArgs {
  bool reload;

  Reload(this.reload);
}

class Counter {
  /// The current [Counter] value.
  int value = 0;

  /// A custom [Event]
  final counterIncremented = Event();

  /// Increment the [Counter] [value] by 1.
  void increment() {
    value++;
    counterIncremented.broadcast(); // Broadcast the change
  }

  /// Reset the [Counter] value to 0.
  void reset() {
    value = 0;
    counterIncremented.broadcast(); // Broadcast the change
  }
}

class HomeOverview extends StatefulWidget {
  HomeOverview({Key? key}) : super(key: key);

  @override
  State<HomeOverview> createState() => HomeOverviewState();
}

class HomeOverviewState extends State<HomeOverview> {
  late String reorderString;
  String? marketCode;
  String? marketName;
  bool? lta;
  StreamSubscription? _reloadStreamSub;
  ScrollController controller = ScrollController();
  Map teaser = {};
  bool isVisible = false;
  final streamController = StreamController<DateTime>.broadcast();

  DateTime startTime = DateTime.now();

  @override
  void dispose() {
    streamController.close();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      isVisible =
          controller.position.userScrollDirection == ScrollDirection.forward;
    });
    /*final subscription = controller.stream.listen((String data) {
      print(data);
    });*/

    Timer.periodic(Duration(seconds: 2), (timer) {
      streamController.add(DateTime.now());
    });
    // streamController.stream.listen((event) {
    //   final time = event.difference(startTime);
    //   updatedTime = time;
    //   print(time.inSeconds);
    // });

    myEvent.subscribe((args) => print('myEvent occured'));
    _reloadStreamSub = eventBus.on<ReloadEvent>().listen((ReloadEvent event) {
      print(event);
      setState(() {});
    });

    // Subscribe to the custom event
    c.counterIncremented.subscribe((args) => print(c.value));
  }

  Future<Home> fetchData() async {
    await getListValuesSF();
    http.Response response = await ApiRepo().getHomePgae(marketCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      //reorderString = await getListValuesSF();
      startTime = DateTime.now();
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
    lta = prefs.getBool(PrefKeys.LTA_CONTAINER) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    late List<Teaser> teaserList = [];

    _reloadStreamSub = eventBus.on<ReloadEvent>().listen((ReloadEvent event) {
      print(event);
      // setState(() {});
    });

    return RefreshIndicator(
      onRefresh: () {
        setState(() {});
        return Future.value();
      },
      color: const Color(0xFFFF6600),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        child: FutureBuilder<Home>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              teaserList = snapshot.data!.teaser;

              List reoderList =
              reorderString == '' ? [] : reorderString.split(',');
              analysisDate = snapshot.data!.analysesDate.toString();
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
                              myEvent.broadcast();
                              Navigator.push(
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
                  controller: controller,
                  // primary: true,
                  shrinkWrap: true,
                  children: [
                    Container(
                      //height: 40,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      color: Theme.of(context).primaryColorDark,
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
                              buildUpdatedTime(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.teaser.length,
                      itemBuilder: (context, index) {
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
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 1.5,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  border: const Border(
                                      bottom: BorderSide(
                                        width: 0.8,
                                        color: Colors.black12,
                                      ))),
                              child: Row(
                                children: [
                                  if (snapshot
                                      .data!.teaser[index].productName ==
                                      'marketCommentary') ...{
                                    MarketCommentaries(
                                      snapshot.data!.teaser[index],
                                    ),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'todaysSignals') ...{
                                    TodaysSignals(
                                      snapshot.data!.teaser[index],
                                    ),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'top20') ...{
                                    TopTwenty(
                                      snapshot.data!.teaser[index],
                                    ),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'indicesAnalyses') ...{
                                    Indices(
                                      snapshot.data!.teaser[index],
                                      'analyses',
                                    ),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'todaysCandidate') ...{
                                    TodaysCandidate(
                                      snapshot.data!.teaser[index],
                                      'case',
                                    ),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'indicesEvaluations') ...{
                                    IndicesEvaluation(
                                        snapshot.data!.teaser[index]),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'barometer') ...{
                                    BarometerGraph(
                                        snapshot.data!.teaser[index].content,
                                        snapshot.data!.teaser[index].title),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'webTV') ...{
                                    WebTVTeaser(snapshot.data!.teaser[index]),
                                  } else if (snapshot
                                      .data!.teaser[index].productName ==
                                      'favourites') ...{
                                    FavoritesTeaser(
                                        snapshot.data!.teaser[index]),
                                  }

                                  //Text(),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    if(lta == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () async{
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    prefs.setBool(PrefKeys.LTA_CONTAINER,
                                        false);

                                    setState((){
                                      lta = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!.lta,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!.lta,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      OpenStore.instance.open(
                                        //appStoreId: 'com.investtech.investtechapp',
                                        androidAppBundleId:
                                        'com.investtech.investtechapp',
                                      );
                                    },
                                    child: Text(
                                      "Get the app",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle:
                                      const TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                    // Container(
                    //     margin: const EdgeInsets.only(
                    //         top: 15, bottom: 10, left: 10, right: 10),
                    //     padding: const EdgeInsets.only(
                    //         top: 0, bottom: 10, left: 10, right: 10),
                    //     color: Color(ColorHex.GREY),
                    //     child: Tooltip(
                    //       message: 'Text()',
                    //       child: SizedBox(
                    //         height: 150,
                    //         child: Column(
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 IconButton(
                    //                   onPressed: () {},
                    //                   icon: const Icon(
                    //                     Icons.close,
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ))
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  StreamBuilder<DateTime> buildUpdatedTime() {
    return StreamBuilder<DateTime>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          int time = snapshot.data?.difference(startTime).inSeconds ?? 0;
          if (time > 60) {
            return Text(
              '${snapshot.data?.difference(startTime).inMinutes} Minute ago',
              style: getSmallestTextStyle(),
            );
          } else if (time > 3600) {
            return Text(
              '${snapshot.data?.difference(startTime).inHours} Hours ago',
              style: getSmallestTextStyle(),
            );
          } else {
            return Text(
              'Just Now',
              style: getSmallestTextStyle(),
            );
          }
        });
  }
}

