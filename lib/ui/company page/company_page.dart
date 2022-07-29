import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/const/theme.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/network/firebase/firebase_services.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/network/models/favorites.dart';
import 'package:investtech_app/ui/blocs/company_bloc.dart';
import 'package:investtech_app/ui/blocs/favourite_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/home/home_page.dart';
import 'package:investtech_app/ui/subscription/subscription_page.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:investtech_app/ui/company%20page/company_body.dart';
import 'package:investtech_app/ui/company%20page/company_header.dart';
import 'package:investtech_app/ui/company%20page/company_price_quote.dart';
import 'package:investtech_app/widgets/no_internet.dart';
import 'package:url_launcher/url_launcher.dart';

import 'company_body.dart';
import 'company_header.dart';
import 'company_price_quote.dart';

class CompanyPage extends StatefulWidget {
  final String cmpId;
  final int chartId;
  String? companyName;
  String? ticker;
  bool? isTop20;
  dynamic currentChartTerm = CHART_TERM_MEDIUM;

  bool isFavourite = false;
  bool hasNote = false;
  bool hasTimestamp = false;

  CompanyPage(this.cmpId, this.chartId,
      {Key? key, this.companyName, this.ticker, this.isTop20})
      : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TextEditingController notesController = TextEditingController();
  AnimationController? controller;

  //late Future future;
  Company? cmpData;
  Color? swtichChartThemeColor;
  bool subscribedUser = false;
  bool hideAppBar = false;
  int type = CHART_STYLE_NORMAL;
  ThemeBloc? bloc;
  int favStateInitialIndex = 1;

  @override
  void initState() {
    // TODO: implement initState

    bloc = context.read<ThemeBloc>();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    controller!.dispose();
    super.dispose();
  }

  String interpolate(String string, List<String> params) {
    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceAll('%$i\$', params[i - 1]);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.short_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.medium_term,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.long_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
    ];

    var chartMap = {0: 5, 1: 4, 2: 6};
    return OrientationBuilder(builder: (context, orientation) {
      return widget.isTop20 == null
          ? Scaffold(
              appBar: orientation == Orientation.landscape
                  ? null
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(56),
                      child: BlocProvider<FavouriteBloc>(
                        create: (BuildContext ctx) {
                          var favBloc = FavouriteBloc(
                            widget.cmpId,
                          );

                          favBloc.add(FavouriteBlocEvents.LOAD_FAVOURITE);
                          return favBloc;
                        },
                        child: BlocBuilder<FavouriteBloc, FavouriteBlocState>(
                          builder: (context, state) {
                            if (state is FavouriteLoadedState) {
                              return buildAppBar(context, state.favData, false);
                            } else if (state is FavouriteModifiedState) {
                              return buildAppBar(context, state.favData, false);
                            } else if (state is FavouriteErrorState) {
                              return AppBar(
                                title: Text(state.error),
                              );
                            } else {
                              return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orange));
                            }
                          },
                        ),
                      ),
                    ),
              body: BlocProvider<CompanyBloc>(
                create: (BuildContext ctx) {
                  var cmpBloc = CompanyBloc(
                    ApiRepo(),
                    widget.cmpId,
                  );
                  cmpBloc.chartId = widget.chartId;
                  cmpBloc.add(CompanyBlocEvents.LOAD_MEDIUM_TERM);
                  return cmpBloc;
                },
                child: BlocBuilder<CompanyBloc, CompanyBlocState>(
                  builder: (context, state) {
                    if (state is CompanyLoadedState) {
                      cmpData = state.cmpData;
                      subscribedUser = state.scuscribedUser;
                      print('object : $subscribedUser');
                      // print(
                      //     'objects : ${jsonDecode(state.favData.toString())['isFavourite']}');

                      return cmpData == null
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Color(ColorHex.ACCENT_COLOR),
                            ))
                          : orientation == Orientation.landscape
                              ? LandscapeMode(
                                  cmpData, subscribedUser, CHART_TERM_MEDIUM)
                              : PortraitMode(cmpData, subscribedUser);
                    } else if (state is CompanyErrorState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoInternet(state.error),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CompanyBloc>()
                                  .add(CompanyBlocEvents.LOAD_COMPANY);
                            },
                            child: Text(AppLocalizations.of(context)!.refresh),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(ColorHex.ACCENT_COLOR)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white)),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange)),
                      );
                    }
                  },
                ),
              ),
            )
          : DefaultTabController(
              length: 3,
              initialIndex: favStateInitialIndex,
              child: Scaffold(
                  appBar: orientation == Orientation.landscape
                      ? null
                      : PreferredSize(
                          preferredSize: const Size.fromHeight(100),
                          child: BlocProvider<FavouriteBloc>(
                            create: (BuildContext ctx) {
                              var favBloc = FavouriteBloc(
                                widget.cmpId,
                              );

                              favBloc.add(FavouriteBlocEvents.LOAD_FAVOURITE);
                              return favBloc;
                            },
                            child:
                                BlocBuilder<FavouriteBloc, FavouriteBlocState>(
                              builder: (context, state) {
                                if (state is FavouriteLoadedState) {
                                  return buildAppBar(
                                      context, state.favData, true);
                                } else if (state is FavouriteModifiedState) {
                                  return buildAppBar(
                                      context, state.favData, true);
                                } else if (state is FavouriteErrorState) {
                                  return AppBar(
                                    title: Text(state.error),
                                  );
                                } else {
                                  return const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.orange));
                                }
                              },
                            ),
                          ),
                        ),
                  body: BlocProvider<CompanyBloc>(
                    create: (BuildContext ctx) {
                      var cmpBloc = CompanyBloc(
                        ApiRepo(),
                        widget.cmpId,
                      );
                      cmpBloc.chartId = widget.chartId;
                      cmpBloc.add(CompanyBlocEvents.LOAD_MEDIUM_TERM);
                      return cmpBloc;
                    },
                    child: BlocBuilder<CompanyBloc, CompanyBlocState>(
                      builder: (context, state) {
                        if (state is CompanyLoadedState) {
                          cmpData = state.cmpData;
                          subscribedUser = state.scuscribedUser;
                          print('object : $subscribedUser');
                          // print(
                          //     'objects : ${jsonDecode(state.toString())['isFavourite']}');

                          return cmpData == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Color(ColorHex.ACCENT_COLOR),
                                ))
                              : orientation == Orientation.portrait
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: TabBarView(
                                        children: tabs.map((Tab tab) {
                                          return PageView.builder(
                                            itemBuilder: (context, position) {
                                              widget.currentChartTerm =
                                                  chartMap[tabs.indexOf(tab)];

                                              // favStateInitialIndex =
                                              //     tabs.indexOf(tab);
                                              // print(favStateInitialIndex);
                                              // if (tabs.indexOf(tab) == 0 &&
                                              //     state.initialIndex !=
                                              //         tabs.indexOf(tab)) {
                                              //   context.read<CompanyBloc>().add(
                                              //       CompanyBlocEvents
                                              //           .LOAD_SHORT_TERM);
                                              // } else if (tabs.indexOf(tab) ==
                                              //         1 &&
                                              //     state.initialIndex !=
                                              //         tabs.indexOf(tab)) {
                                              //   context.read<CompanyBloc>().add(
                                              //       CompanyBlocEvents
                                              //           .LOAD_MEDIUM_TERM);
                                              // } else if (tabs.indexOf(tab) ==
                                              //         2 &&
                                              //     state.initialIndex !=
                                              //         tabs.indexOf(tab)) {
                                              //   context.read<CompanyBloc>().add(
                                              //       CompanyBlocEvents
                                              //           .LOAD_LONG_TERM);
                                              // }
                                              // print(
                                              //     'debug: ${state.cmpData.commentText}');
                                              return CompanyBody(
                                                widget.cmpId,
                                                widget.currentChartTerm,
                                                'paid',
                                              );
                                            },
                                            itemCount: 1,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : LandscapeMode(cmpData, subscribedUser,
                                      widget.currentChartTerm);
                        } else if (state is CompanyErrorState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NoInternet(state.error),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<CompanyBloc>()
                                      .add(CompanyBlocEvents.LOAD_COMPANY);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.refresh),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(ColorHex.ACCENT_COLOR)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange)),
                          );
                        }
                      },
                    ),
                  )));
    });
  }

  Widget PortraitMode(cmpData, subscribedUser) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    //print(snapshot.data);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompanyHeader(
              ticker: cmpData!.ticker,
              companyName: cmpData!.name.toString(),
              changePct: cmpData!.changePct,
              changeValue: cmpData!.change!.toString(),
              close: cmpData!.closePrice!,
              evaluation: cmpData!.evaluationText.toString(),
              evalCode: cmpData!.evaluationCode,
              priceDate: cmpData!.priceDate,
              showDate: 'show',
              chartId: widget.chartId.toString(),
              access: 'paid',
              subscribedUser: subscribedUser,
              //market: companyObj.marketCode.toString(),
            ), //companyObj.term.toString(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: [SystemUiOverlay.bottom]);
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]);
                  } else {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  }
                },
                child: CachedNetworkImage(
                  imageUrl: ApiRepo().getChartUrl(
                      subscribedUser ? CHART_TYPE_ADVANCED : CHART_TYPE_FREE,
                      widget.chartId,
                      bloc!.loadTheme == AppTheme.lightTheme
                          ? CHART_STYLE_NORMAL
                          : CHART_STYLE_BLACK,
                      widget.cmpId),
                  placeholder: (context, url) => Container(
                      height: 275,
                      width: double.infinity,
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: Color(
                        ColorHex.ACCENT_COLOR,
                      )))),
                  errorWidget: (context, url, error) => SizedBox(
                      height: 275,
                      width: double.infinity,
                      child: Center(
                          child:
                              Image.asset('assets/images/no_thumbnail.png'))),
                ),
              ),
            ),
            subscribedUser
                ? Text(
                    cmpData!.commentText.toString().replaceAll('\\', ''),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )
                : RichText(
                    text: TextSpan(
                        text:
                            '${cmpData!.commentText.toString().substring(0, 110)}... ',
                        style: Theme.of(context).textTheme.bodyText2,
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context)!.read_more,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Subscription(),
                                      ));
                                },
                              style: const TextStyle(
                                  // color: bloc!.loadTheme == AppTheme.lightTheme
                                  //     ? const Color(ColorHex.black)
                                  //     : const Color(ColorHex.white),
                                  color: Color(ColorHex.ACCENT_COLOR)
                                  //decoration: TextDecoration.underline,
                                  ))
                        ]),
                  ),

            const SizedBox(
              height: 10,
            ),

            Text(
              'Market: ${cmpData!.marketName}',
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Linkify(
              options: const LinkifyOptions(defaultToHttps: true),
              onOpen: (link) async {
                if (await canLaunchUrl(Uri.parse(link.url))) {
                  await launchUrl(Uri.parse(link.url));
                } else {
                  throw 'Could not launch $link';
                }
              },
              text: AppLocalizations.of(context)!
                  .short_disclaimer
                  .replaceAll('\\', ''),
              style: getSmallestTextStyle(),
              textAlign: TextAlign.center,
              linkStyle: const TextStyle(
                color: Color(ColorHex.teal),
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget LandscapeMode(cmpData, subscribedUser, currentChartId) {
    var _height = 0;
    var pixelRatio = window.devicePixelRatio;
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    //var logicalHeight = logicalScreenSize.height;

    int width = logicalWidth.toInt();
    int height = (width * 0.6).toInt();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        if (controller!.isDismissed) {
          controller!.forward();
        }
      }
    });

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (controller!.isCompleted) {
              controller!.reverse();
            } else {
              controller!.forward();
            }
          },
          child: CachedNetworkImage(
            width: double.infinity,
            imageUrl: ApiRepo().getChartUrl(
                subscribedUser ? CHART_TYPE_ADVANCED : CHART_TYPE_FREE,
                currentChartId,
                type,
                widget.cmpId,
                '$width,$height'),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                //height: 275,
                width: double.infinity,
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Color(
                  ColorHex.ACCENT_COLOR,
                )))),
            errorWidget: (context, url, error) => SizedBox(
                height: 275,
                width: double.infinity,
                child: Center(
                    child: Image.asset('assets/images/no_thumbnail.png'))),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: AnimatedBuilder(
              animation: controller!,
              builder: (context, child) => Stack(
                    children: [
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.currentChartTerm = currentChartId;
                              if (type == CHART_STYLE_BLACK) {
                                type = CHART_STYLE_NORMAL;
                                swtichChartThemeColor = Colors.black;
                              } else {
                                type = CHART_STYLE_BLACK;
                                swtichChartThemeColor = Colors.white;
                              }
                            });
                          },
                          child: Transform.translate(
                            offset: Offset(0, -controller!.value * -50),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: swtichChartThemeColor ?? Colors.black,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(100.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -controller!.value * 64),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: type == CHART_STYLE_NORMAL
                                ? Colors.black
                                : Colors.white,
                          ),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: type == CHART_STYLE_NORMAL
                                    ? Colors.white
                                    : Colors.black,
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
                            child: Row(children: [
                              CompanyPriceQuote(cmpData, subscribedUser),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: InkWell(
                                    onTap: () {
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
                                    child: const Icon(Icons.close)),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context, favData, isTop20) {
    List<Tab> tabs = [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.short_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.medium_term,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.long_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
    ];

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 230,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: const Color(0xFF9E9E9E),
      content: Text(
        AppLocalizations.of(context)!.saved_to_favorites,
        style: const TextStyle(color: Colors.white),
      ),
      //duration: Duration(seconds: 3),
    );

    if (jsonDecode(favData.toString())['isFavourite']) {
      widget.isFavourite = jsonDecode(favData.toString())['isFavourite'];
      widget.hasNote =
          jsonDecode(favData.toString())['note'].toString().isNotEmpty
              ? true
              : false;
      widget.hasTimestamp =
          jsonDecode(favData.toString())['timeStamp'] != false ? true : false;

      notesController.text = jsonDecode(favData.toString())['note'].toString();
    } else {
      widget.isFavourite = jsonDecode(favData.toString())['isFavourite'];
      widget.hasNote = jsonDecode(favData.toString())['note'];
      notesController.text = '';
    }

    var appBarAction = [
      InkWell(
        onTap: () async {
          if (widget.isFavourite && widget.hasNote) {
            showDialog<String>(
              context: context,
              builder: (BuildContext ctx) => AlertDialog(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                title: Text(AppLocalizations.of(context)!.are_you_sure),
                content:
                    Text(AppLocalizations.of(context)!.note_exists_warning),
                actions: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        height: 25,
                        child: TextButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all(const Size(50, 25)),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(5)),
                          ),
                          child: SizedBox(
                            height: 25,
                            child: Text(
                              AppLocalizations.of(context)!.delete,
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                          onPressed: () async {
                            await DatabaseHelper()
                                .deleteNoteAndFavourite(widget.cmpId);
                            eventBus.fire(ReloadEvent());
                            context
                                .read<FavouriteBloc>()
                                .add(FavouriteBlocEvents.FAVOURITE_MODIFIED);

                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      TextButton(
                        //height: 25,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (widget.isFavourite) {
            int deleteFlag =
                await DatabaseHelper().deleteNoteAndFavourite(widget.cmpId);
            print(deleteFlag);

            context
                .read<FavouriteBloc>()
                .add(FavouriteBlocEvents.FAVOURITE_MODIFIED);
            eventBus.fire(ReloadEvent());
            myEvent.broadcast(Reload(true));
          } else {
            var favorite = Favorites(
                companyName: widget.companyName ?? "",
                companyId: int.parse(widget.cmpId),
                ticker: widget.ticker ?? "",
                note: notesController.text,
                noteTimestamp:
                    DateTime.now().millisecondsSinceEpoch.toString());
            await DatabaseHelper().addNoteAndFavorite(favorite);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            eventBus.fire(ReloadEvent());
            //future = DatabaseHelper().checkNoteAndFavorite(widget.cmpId);
            print('adding');

            context
                .read<FavouriteBloc>()
                .add(FavouriteBlocEvents.FAVOURITE_MODIFIED);
          }
        },
        child: Icon(
          widget.isFavourite ? Icons.star_outlined : Icons.star_border_outlined,
          color: const Color(ColorHex.ACCENT_COLOR),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              // dialog is dismissible with a tap on the barrier
              useSafeArea: true,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  actionsPadding: EdgeInsets.zero,
                  title: Text(
                    '${widget.companyName} (${widget.ticker})',
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.notes,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: notesController,
                              style: const TextStyle(fontSize: 12),
                              cursorColor: const Color(0xFFEF6C00),
                              maxLines: 8,
                              //autofocus: true,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: (Colors.grey[600])!),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: (Colors.grey[600])!),
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              onChanged: (value) {
                                //teamName = value;
                              },
                            ))
                          ],
                        ),
                        if (widget.hasTimestamp)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.hasTimestamp
                                    ? jsonDecode(favData.toString())[
                                                    'timeStamp']
                                                .toString() ==
                                            "false"
                                        ? ''
                                        : '${AppLocalizations.of(context)!.last_modified} : ${AppLocalizations.of(context)!.note_timestamp(DateTime.fromMillisecondsSinceEpoch(int.parse(jsonDecode(favData.toString())['timeStamp'])))}'
                                    : '',
                                style: getSmallestTextStyle(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    Column(
                      children: [
                        SizedBox(
                          height: 25,
                          child: TextButton(
                            style: ButtonStyle(
                              fixedSize:
                                  MaterialStateProperty.all(const Size(50, 25)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(5)),
                            ),
                            child: SizedBox(
                              height: 25,
                              child: Text(
                                AppLocalizations.of(context)!.save,
                                style: const TextStyle(
                                    color: Color(ColorHex.ACCENT_COLOR)),
                              ),
                            ),
                            onPressed: () async {
                              var favorite = Favorites(
                                  companyName: widget.companyName ?? "",
                                  companyId: int.parse(widget.cmpId),
                                  ticker: widget.ticker ?? "",
                                  note: notesController.text,
                                  noteTimestamp: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                              await DatabaseHelper()
                                  .addNoteAndFavorite(favorite);
                              eventBus.fire(ReloadEvent());
                              context
                                  .read<FavouriteBloc>()
                                  .add(FavouriteBlocEvents.FAVOURITE_MODIFIED);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        TextButton(
                          //height: 25,
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: const TextStyle(
                                color: Color(ColorHex.ACCENT_COLOR)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            widget.hasNote ? Icons.mode_comment : Icons.mode_comment_outlined,
            color: const Color(ColorHex.ACCENT_COLOR),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: InkWell(
          onTap: () async {
            String mylink =
                await createDynamicLink(widget.cmpId, widget.companyName);
            var shareText = interpolate(
                AppLocalizations.of(context)!.share_message_template,
                [widget.companyName.toString(), mylink]);

            await FlutterShare.share(
              title: shareText,
              text: shareText,
            );
          },
          child: const Icon(
            Icons.share,
            color: Color(ColorHex.ACCENT_COLOR),
          ),
        ),
      ),
    ];

    return isTop20
        ? AppBar(
            actions: appBarAction,
            bottom: TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              tabs: tabs,
            ),
          )
        : AppBar(
            actions: appBarAction,
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
