import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/web_tv.dart';
import 'package:investtech_app/ui/blocs/indices_eval_bloc.dart';
import 'package:investtech_app/widgets/no_internet.dart';

import 'package:investtech_app/ui/web%20tv/web_tv_item.dart';

class WebTVList extends StatefulWidget {
  const WebTVList({Key? key}) : super(key: key);

  @override
  State<WebTVList> createState() => _WebTVListState();
}

class _WebTVListState extends State<WebTVList> {
  Future<WebLinkDetail>? future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = fetchData();
  }

  Future<WebLinkDetail> fetchData() async {
    Response response = await ApiRepo().getWebTVList();
    if (response.statusCode == 200) {
      return WebLinkDetail.fromJson(jsonDecode(jsonEncode(response.data)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.web_tv),
        ),
        body: FutureBuilder<WebLinkDetail>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.video!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (ctx, index) {
                      return WebTVItem(
                          videoContent: snapshot.data!.video![index]);
                    }),
              );
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoInternet(snapshot.error.runtimeType.toString()),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        future = fetchData();
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.refresh),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color(ColorHex.ACCENT_COLOR)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                  ),
                ],
              );
            } else {
              return const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange)));
            }
          },
        ));
  }
}
