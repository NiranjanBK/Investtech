import 'dart:async';

import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/recent_search.dart';
import 'package:investtech_app/network/models/search_result.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/widgets/control_visibility.dart';
import 'package:investtech_app/widgets/recent_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchItemPage extends StatefulWidget {
  BuildContext context;
  SearchItemPage(this.context, {Key? key}) : super(key: key);

  @override
  _SearchItemPageState createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  List<SearchResult>? searchResult;
  SearchBloc? bloc;
  String? q;
  bool? isLoading;

  VisibilityController linearProgressIndicator = VisibilityController(false);
  final Debounce _debounce = Debounce(Duration(milliseconds: 1000));

  @override
  void initState() {
    super.initState();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    bloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> list = [
      DropdownMenuItem(
          value: globalMarketId,
          child: Text(AppLocalizations.of(context)!.stocks)),
      DropdownMenuItem(
          value: "992", child: Text(AppLocalizations.of(context)!.indices)),
      DropdownMenuItem(
          value: "993", child: Text(AppLocalizations.of(context)!.currencies)),
      DropdownMenuItem(
          value: "980", child: Text(AppLocalizations.of(context)!.commodities))
    ];

    final Map<String, String> dropdownVal = {
      globalMarketId: AppLocalizations.of(context)!.stocks,
      "992": AppLocalizations.of(context)!.indices,
      "993": AppLocalizations.of(context)!.currencies,
      "980": AppLocalizations.of(context)!.commodities
    };

    return Scaffold(
      appBar: AppBar(
          // iconTheme: const IconThemeData(
          //   color: Colors.black, //change your color here
          // ),
          // backgroundColor: Colors.white,
          bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 1),
              child: SizedBox(
                height: 1,
                child: ControlledVisibility(
                    linearProgressIndicator,
                    LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.orange[800],
                    )),
              )),
          // The search area here
          title: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                cursorColor: Colors.orange[800],
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search.toString(),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _debounce(() {
                    bloc!.searchTerm = value;
                    bloc!.marketId = globalMarketId;
                    bloc!.add(SearchBlocEvents.LOAD_SEARCH);
                    linearProgressIndicator.setVisibility(true);
                  });
                },
              ),
            ),
          )),
      body: BlocBuilder<SearchBloc, SearchBlocState>(builder: (context, state) {
        if (state is SearchLoadedState) {
          linearProgressIndicator.setVisibility(false);
          searchResult = state.searchResult;
        }
        if (state is SearchLoadingState) {
          //linearProgressIndicator.setVisibility(true);
        }
        return Container(
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: searchResult == null
              ? const RecentSearchList()
              : ListView(
                  children: [
                    ListTile(
                      leading:
                          Text(AppLocalizations.of(context)!.search_results),
                      trailing: DropdownButton<String>(
                        dropdownColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        hint: Text(
                          dropdownVal[
                                  bloc!.selectedDropdwonVal ?? globalMarketId]
                              .toString(),
                          style: DefaultTextStyle.of(context).style,
                        ),
                        items: list,
                        onChanged: (value) {
                          bloc!.marketId = value;
                          bloc!.selectedDropdwonVal = value;
                          bloc!.add(SearchBlocEvents.LOAD_SEARCH);
                          linearProgressIndicator.setVisibility(true);
                        },
                      ),
                    ),
                    ListView.separated(
                      itemCount: searchResult!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 0,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: (Colors.grey[400])!, width: 0.5))),
                          child: InkWell(
                            onTap: () async {
                              var recentSearch = RecentSearch(
                                  ticker: searchResult![index].ticker,
                                  companyId: searchResult![index].companyId,
                                  countryCode: searchResult![index].countryCode,
                                  companyName: searchResult![index].companyName,
                                  timestamp: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString());
                              DatabaseHelper().addRecentSearch(recentSearch);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyPage(
                                        searchResult![index].companyId, 4,
                                        companyName:
                                            searchResult![index].companyName,
                                        ticker: searchResult![index].ticker),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Image.asset(
                                      'assets/images/flags/h20/${searchResult![index].countryCode}.png',
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        searchResult![index].ticker,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        searchResult![index].companyName,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        double.parse((searchResult![index]
                                                .lastClose))
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        '${double.parse((searchResult![index].changeVal))}(${double.parse((searchResult![index].changePct)).toStringAsFixed(2)}%)',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: double.parse(
                                                        (searchResult![index]
                                                            .changeVal)) >
                                                    0
                                                ? Colors.green[900]
                                                : Colors.red[900]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        );
      }),
    );
  }
}

class Debounce {
  Duration delay;
  Timer? _timer;

  Debounce(
    this.delay,
  );

  call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  dispose() {
    _timer?.cancel();
  }
}
