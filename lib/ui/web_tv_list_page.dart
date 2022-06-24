import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/web_tv.dart';
import 'package:http/http.dart' as http;
import 'package:investtech_app/ui/web_tv_youTube_page.dart';
import 'package:investtech_app/widgets/web_tv_item.dart';

class WebTVList extends StatelessWidget {
  const WebTVList({Key? key}) : super(key: key);

  Future<WebLinkDetail> fetchData() async {
    http.Response response = await ApiRepo().getWebTVList();
    if (response.statusCode == 200) {
      return WebLinkDetail.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebLinkDetail>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.web_tv),
            ),
            body: SingleChildScrollView(
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
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
