import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/country.dart';
import 'package:investtech_app/network/models/market.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class MarketSelection extends StatefulWidget {
  const MarketSelection({Key? key}) : super(key: key);

  @override
  _MarketSelectionState createState() => _MarketSelectionState();
}

class _MarketSelectionState extends State<MarketSelection> {
  late Future<List<COUNTRY>> country;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MARKET>>(
      future: DatabaseHelper().getMarketDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Market'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: snapshot.data != null
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(PrefKeys.SELECTED_MARKET,
                                  snapshot.data![index].marketName);
                              prefs.setString(PrefKeys.SELECTED_MARKET_CODE,
                                  snapshot.data![index].marketCode);
                              prefs.setString(PrefKeys.SELECTED_MARKET_ID,
                                  snapshot.data![index].marketId.toString());
                              globalMarketId =
                                  snapshot.data![index].marketId.toString();

                              Navigator.pop(context, {
                                'marketCode': snapshot.data![index].marketCode,
                                'marketName': snapshot.data![index].marketName
                              });
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/images/flags/h20/${snapshot.data![index].countryCode}.png'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data![index].marketName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
