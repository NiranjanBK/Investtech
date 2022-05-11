import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/ui/todays_signals_detail_page.dart';
import 'package:investtech_app/widgets/indices.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';

class TodaysSignals extends StatelessWidget {
  final dynamic _signalData;

  TodaysSignals(this._signalData);

  @override
  Widget build(BuildContext context) {
    var _signals =
        jsonDecode(jsonEncode(_signalData))['content']['signals'] as List;

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TodaysSignalDetailPage(
                        jsonDecode(jsonEncode(_signalData))['title'])),
              );
            },
            child:
                ProductHeader(jsonDecode(jsonEncode(_signalData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _signals.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CompanyPage(_signals[index]['companyId'], 4),
                            ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _signals[index]['ticker'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            _signals[index]['data'],
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
