import 'dart:async';
import 'package:event_bus/event_bus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/theme.dart';

import 'package:investtech_app/network/internet/connection_status.dart';
import 'package:investtech_app/ui/blocs/home_bloc/home_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/widgets/fade_animation.dart';
import 'package:investtech_app/widgets/no_internet.dart';
import 'package:open_store/open_store.dart';
import 'package:investtech_app/const/colors.dart';

import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/main.dart';

import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/market%20selection%20dropdown/market_selection_page.dart';
import 'package:investtech_app/ui/home%20menu/reorder_page.dart';
import 'package:investtech_app/ui/company%20search/search_item_page.dart';
import 'package:investtech_app/ui/home%20menu/settings_page.dart';
import 'package:investtech_app/widgets/barometer.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/ui/favourites/favorites.dart';
import 'package:investtech_app/ui/web%20tv/web_tv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../todays signal/todays_signals.dart';

import '../../network/api_repo.dart';
import '../../network/models/home.dart';
import '../market Commentary/market_commentary.dart';
import '../indices/indices.dart';
import '../../widgets/todays_candidate.dart';
import '../indices evaluation/indices_evaluation.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:event/event.dart';

import '../top20/top20.dart';

EventBus eventBus = EventBus(sync: true);
// final controller = StreamController<String>();

var myEvent = Event<Reload>();

class ReloadEvent {}

// An example custom 'argument' class
class Reload extends EventArgs {
  bool reload;

  Reload(this.reload);
}

class HomeOverview extends StatefulWidget {
  HomeOverview({Key? key}) : super(key: key);

  @override
  State<HomeOverview> createState() => HomeOverviewState();
}

class HomeOverviewState extends State<HomeOverview> {
  String? reorderString;
  String? marketCode;
  String? marketId;
  String? marketName;
  ThemeBloc? themeBloc;
  bool? showTooltip;

  bool? lta;
  StreamSubscription? _reloadStreamSub;
  ScrollController controller = ScrollController();
  Map teaser = {};
  bool isVisible = false;
  final streamController = StreamController<DateTime>.broadcast();

  DateTime startTime = DateTime.now();
  StreamSubscription? _connectionChangeStream;
  bool isOffline = false;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getListValuesSF();
    themeBloc = context.read<ThemeBloc>();
    controller.addListener(() {
      turnOffTooltip();

      isVisible =
          controller.position.userScrollDirection == ScrollDirection.forward;
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!streamController.isClosed) streamController.add(DateTime.now());
    });
    myEvent.subscribe((args) => print('myEvent occured'));
    _reloadStreamSub = eventBus.on<ReloadEvent>().listen((ReloadEvent event) {
      print(event);
      BlocProvider.of<HomeBloc>(context).add(GetHomePageEvent(marketCode));
    });
    // Subscribe to the custom event
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();

    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);

    startTime = DateTime.now();
    BlocProvider.of<HomeBloc>(context).add(GetHomePageEvent(marketCode));
  }

  turnOffTooltip() async {
    if (showTooltip!) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(PrefKeys.SHOW_TOOLTIP, false);
      setState(() {
        showTooltip = false;
      });
    }
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  /*Future<Home> fetchData() async {
    await getListValuesSF();
    Response response = await ApiRepo().getHomePgae(marketCode);
    if (response.statusCode == 200) {

      startTime = DateTime.now();

      return Home.fromJson(jsonDecode(jsonEncode(response.data)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }*/

  void awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketSelection(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    if (result != null) {
      setState(() {
        marketCode = result['marketCode'];
        marketName = result['marketName'];
      });
      BlocProvider.of<HomeBloc>(context).add(GetHomePageEvent(marketCode));
    }
  }

  FutureOr onGoBack(dynamic value) {
    BlocProvider.of<HomeBloc>(context).add(GetHomePageEvent(marketCode));
  }

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reorderString = prefs.getString('items') ?? '';

    marketName = prefs.getString(PrefKeys.SELECTED_MARKET) ?? 'National S.E';
    marketCode = prefs.getString(PrefKeys.SELECTED_MARKET_CODE) ?? 'in_nse';
    marketId = prefs.getString(PrefKeys.SELECTED_MARKET_ID) ?? '911';
    lta = prefs.getBool(PrefKeys.LTA_CONTAINER) ?? false;
    showTooltip = prefs.getBool(PrefKeys.SHOW_TOOLTIP) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    late List<Teaser> teaserList = [];

    _reloadStreamSub = eventBus.on<ReloadEvent>().listen((ReloadEvent event) {
      print(event);
      // setState(() {});
    });

    return RefreshIndicator(
      edgeOffset: 100,
      onRefresh: () {
        startTime = DateTime.now();
        BlocProvider.of<HomeBloc>(context).add(GetHomePageEvent(marketCode));
        return Future.value();
      },
      color: const Color(0xFFFF6600),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
          if (state is HomeLoadedState) {
            teaserList = state.home.teaser;

            analysisDate = state.home.analysesDate.toString();
            return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool(PrefKeys.SHOW_TOOLTIP, false);
                setState(() {
                  showTooltip = false;
                });
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColorDark,
                appBar: buildAppBar(context, teaserList),
                body: ListView(
                  controller: controller,
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 40,
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
                                        int.parse(state.home.analysesDate) *
                                            1000)),
                            style: getSmallestTextStyle(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .last_updated_home_header_template,
                                style: getSmallestTextStyle(),
                              ),
                              buildUpdatedTime(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.home.teaser.length,
                      itemBuilder: (context, index) {
                        return FadeAnimation(
                          delay: 2,
                          child: Container(
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
                                if (state.home.teaser[index].productName ==
                                    'marketCommentary') ...{
                                  MarketCommentaries(
                                    state.home.teaser[index],
                                  ),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'todaysSignals') ...{
                                  TodaysSignals(
                                    state.home.teaser[index],
                                  ),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'top20') ...{
                                  TopTwenty(
                                    state.home.teaser[index],
                                  ),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'indicesAnalyses') ...{
                                  Indices(
                                    state.home.teaser[index],
                                    'analyses',
                                  ),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'todaysCandidate') ...{
                                  TodaysCandidate(
                                    state.home.teaser[index],
                                    'case',
                                  ),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'indicesEvaluations') ...{
                                  IndicesEvaluation(state.home.teaser[index]),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'barometer') ...{
                                  BarometerGraph(
                                      state.home.teaser[index].content,
                                      state.home.teaser[index].title),
                                } else if (state
                                            .home.teaser[index].productName ==
                                        'webTV' &&
                                    ["ose", "se_sse", "dk_kfx", "dk_inv"]
                                        .contains(marketCode)) ...{
                                  WebTVTeaser(state.home.teaser[index]),
                                } else if (state
                                        .home.teaser[index].productName ==
                                    'favourites') ...{
                                  FavoritesTeaser(state.home.teaser[index]),
                                }

                                //Text(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (lta == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/lta_teaser_bg.png'),
                                  fit: BoxFit.cover),
                              color: const Color(ColorHex.black_chart_bg),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool(
                                        PrefKeys.LTA_CONTAINER, false);

                                    setState(() {
                                      lta = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  color: const Color(ColorHex.lightGrey),
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
                                      AppLocalizations.of(context)!.lta_info,
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
                                            'com.investtech.learn_technical_analysis',
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.get_the_app,
                                      style:
                                          const TextStyle(color: Colors.orange),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor,
                                      textStyle: const TextStyle(
                                          color: Color(ColorHex.ACCENT_COLOR)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else if (state is ErrorState) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoInternet(state.errorBody),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<HomeBloc>(context)
                          .add(GetHomePageEvent(marketCode));
                    },
                    child: Text(AppLocalizations.of(context)!.refresh),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color(ColorHex.ACCENT_COLOR)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
          }
        }),
        /*: FutureBuilder<Home>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      teaserList = snapshot.data!.teaser;
                      List reoderList =
                          reorderString == '' ? [] : reorderString.split(',');
                      analysisDate = snapshot.data!.analysesDate.toString();
                      return Scaffold(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        appBar: buildAppBar(context, teaserList),
                        body: ListView(
                          controller: controller,
                          shrinkWrap: true,
                          children: [
                            Container(
                              height: 40,
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
                                                int.parse(snapshot
                                                        .data!.analysesDate) *
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
                            Container(
                              height: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.teaser.length,
                              itemBuilder: (context, index) {
                                return FadeAnimation(
                                  delay: 2,
                                  child: Container(
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
                                        if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'marketCommentary') ...{
                                          MarketCommentaries(
                                            snapshot.data!.teaser[index],
                                          ),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'todaysSignals') ...{
                                          TodaysSignals(
                                            snapshot.data!.teaser[index],
                                          ),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'top20') ...{
                                          TopTwenty(
                                            snapshot.data!.teaser[index],
                                          ),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'indicesAnalyses') ...{
                                          Indices(
                                            snapshot.data!.teaser[index],
                                            'analyses',
                                          ),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'todaysCandidate') ...{
                                          TodaysCandidate(
                                            snapshot.data!.teaser[index],
                                            'case',
                                          ),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'indicesEvaluations') ...{
                                          IndicesEvaluation(
                                              snapshot.data!.teaser[index]),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'barometer') ...{
                                          BarometerGraph(
                                              snapshot
                                                  .data!.teaser[index].content,
                                              snapshot
                                                  .data!.teaser[index].title),
                                        } else if (snapshot.data!.teaser[index]
                                                    .productName ==
                                                'webTV' &&
                                            [
                                              "ose",
                                              "se_sse",
                                              "dk_kfx",
                                              "dk_inv"
                                            ].contains(marketCode)) ...{
                                          WebTVTeaser(
                                              snapshot.data!.teaser[index]),
                                        } else if (snapshot.data!.teaser[index]
                                                .productName ==
                                            'favourites') ...{
                                          FavoritesTeaser(
                                              snapshot.data!.teaser[index]),
                                        }

                                        //Text(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (lta == true)
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
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool(
                                                PrefKeys.LTA_CONTAINER, false);

                                            setState(() {
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
                                                  fontSize: 14,
                                                  color: Colors.white),
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
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              textStyle: const TextStyle(
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }

                    // By default, show a loading spinner.
                    return const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange)));
                  },
                )*/
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, List<Teaser> teaserList) {
    return AppBar(
      title: InkWell(
        onTap: () {
          awaitReturnValueFromSecondScreen(context);
        },
        child: SimpleTooltip(
          tooltipDirection: TooltipDirection.down,
          arrowTipDistance: 2,
          arrowLength: 10,
          hideOnTooltipTap: true,
          borderColor: themeBloc!.loadTheme == AppTheme.lightTheme
              ? const Color(ColorHex.darkColorPrimary)
              : const Color(ColorHex.white),
          backgroundColor: themeBloc!.loadTheme == AppTheme.lightTheme
              ? const Color(ColorHex.darkColorPrimary)
              : const Color(ColorHex.white),
          show: showTooltip!,
          ballonPadding: const EdgeInsets.all(0),
          targetCenter: const Offset(40, 40),
          content: Text(
            'Introducing Crypto Currencies! Now available as a new market',
            style: TextStyle(
                fontSize: DefaultTextStyle.of(context).style.fontSize,
                color: themeBloc!.loadTheme == AppTheme.darkTheme
                    ? const Color(ColorHex.darkColorPrimary)
                    : const Color(ColorHex.white),
                decoration: DefaultTextStyle.of(context).style.decoration),
          ),
          child: Row(
            children: [
              Text(
                marketName ?? 'National S.E',
                style: const TextStyle(fontSize: 15),
              ),
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
                        builder: (context) => ReorderPage(teaserList,
                            reorderString.toString(), marketCode.toString()),
                      ));
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
                          color: Theme.of(context).textTheme.bodyText2!.color),
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
                          color: Theme.of(context).textTheme.bodyText2!.color),
                    ),
                  ),
                ])
      ],
    );
  }

  StreamBuilder<DateTime> buildUpdatedTime() {
    return StreamBuilder<DateTime>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          int time = snapshot.data?.difference(startTime).inSeconds ?? 0;
          if (time > 60) {
            return Text(
              '${snapshot.data?.difference(startTime).inMinutes} ${AppLocalizations.of(context)!.minutes} ${AppLocalizations.of(context)!.ago}',
              style: getSmallestTextStyle(),
            );
          } else if (time > 3600) {
            return Text(
              '${snapshot.data?.difference(startTime).inHours} ${AppLocalizations.of(context)!.hour} ${AppLocalizations.of(context)!.ago}',
              style: getSmallestTextStyle(),
            );
          } else {
            return Text(
              AppLocalizations.of(context)!.just_now,
              style: getSmallestTextStyle(),
            );
          }
        });
  }
}
