import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/widgets/chart_view.dart';
import 'package:investtech_app/widgets/favourites_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:investtech_app/ui/home_page.dart';

class FavoritesDetail extends StatefulWidget {
  final List<Company> favCmpObj;
  bool isNoFavourites = false;

  FavoritesDetail(this.favCmpObj, {Key? key}) : super(key: key);

  @override
  State<FavoritesDetail> createState() => _FavoritesDetailState();
}

class _FavoritesDetailState extends State<FavoritesDetail> {
  late Future future;
  bool hasAdvancedChartSubscription = false;

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasAdvancedChartSubscription =
        prefs.getBool(PrefKeys.ADVANCED_CHART) ?? false;
    return prefs.getString(PrefKeys.selectedDataView) ?? 'TableView';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = getListValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = widget.favCmpObj.length;
    return widget.isNoFavourites || itemCount == 0
        ? Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.favourites),
            ),
            body: Center(
                child: Text(
              AppLocalizations.of(context)!.empty_favorites,
              style: getSmallTextStyle(),
            )),
          )
        : FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.favourites),
                    actions: [
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (snapshot.data == 'TableView') {
                            await prefs.setString(
                                PrefKeys.selectedDataView, 'ChartView');
                          } else {
                            await prefs.setString(
                                PrefKeys.selectedDataView, 'TableView');
                          }

                          setState(() {
                            future = getListValuesSF();
                          });
                        },
                        child: snapshot.data == 'TableView'
                            ? Container(
                                height: 10,
                                padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color(ColorHex.ACCENT_COLOR)),
                                child: const Icon(
                                  Icons.bar_chart,
                                  color: Color(ColorHex.white),
                                ))
                            : Container(
                                height: 10,
                                padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.all(15),
                                child: const Icon(
                                  Icons.list_sharp,
                                  color: Color(ColorHex.ACCENT_COLOR),
                                ),
                              ),
                      ),
                      PopupMenuButton(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          onSelected: (value) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                title: Text(
                                    AppLocalizations.of(context)!.are_you_sure),
                                content: Text(AppLocalizations.of(context)!
                                    .delete_all_favorites_message),
                                actions: <Widget>[
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        child: TextButton(
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size(50, 25)),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(5)),
                                          ),
                                          child: SizedBox(
                                            height: 25,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .delete,
                                              style: TextStyle(
                                                  color: Colors.orange[800]),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await DatabaseHelper()
                                                .deleteAllNotesAndFavourites();

                                            setState(() {
                                              eventBus.fire(ReloadEvent());
                                              widget.isNoFavourites = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        //height: 25,
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.orange[800]),
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
                          },
                          itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  height: 30,
                                  value: 'delete',
                                  child: Text(
                                    AppLocalizations.of(context)!.delete_all,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color),
                                  ),
                                  onTap: () {},
                                ),
                              ])
                    ],
                  ),
                  body: snapshot.data == 'ChartView'
                      ? SingleChildScrollView(
                          child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              shrinkWrap: true,
                              itemCount: itemCount,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (ctx, index) {
                                print(widget.favCmpObj[index].priceDate
                                    .toString());
                                return ChartView(
                                    widget.favCmpObj[index].Id.toString(),
                                    4,
                                    widget.favCmpObj[index].Name.toString(),
                                    widget.favCmpObj[index].ticker,
                                    widget.favCmpObj[index].PriceDate
                                        .toString(),
                                    widget.favCmpObj[index].closePrice
                                        .toString(),
                                    widget.favCmpObj[index].changePct
                                        .toString(),
                                    hasAdvancedChartSubscription);
                              }),
                        )
                      : SingleChildScrollView(
                          child: FavoritesList(widget.favCmpObj, itemCount),
                        ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
  }
}
