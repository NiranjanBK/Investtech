import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/models/search_result.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/widgets/control_visibility.dart';

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
    bloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                cursorColor: Colors.orange[800],
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _debounce(() {
                    bloc!.searchTerm = value;
                    bloc!.marketId = '911';
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
        return searchResult == null
            ? const Text('Recent searches')
            : ListView.builder(
                itemCount: searchResult!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: (Colors.grey[400])!, width: 0.5))),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyPage(
                                searchResult![index].companyId,
                                4,
                              ),
                            ));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${index + 1}.',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                searchResult![index].ticker,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
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
                                double.parse((searchResult![index].lastClose))
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                              Text(
                                '${double.parse((searchResult![index].changeVal))}(${double.parse((searchResult![index].changePct)).toStringAsFixed(2)}%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: double.parse((searchResult![index]
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
                  );
                },
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
