import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';
import 'package:investtech_app/ui/todays%20signal/todays_signals_detail_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';

class TodaysSignals extends StatefulWidget {
  final dynamic _signalData;

  TodaysSignals(this._signalData);

  @override
  State<TodaysSignals> createState() => _TodaysSignalsState();
}

class _TodaysSignalsState extends State<TodaysSignals> {
  @override
  Widget build(BuildContext context) {
    var _signals = jsonDecode(jsonEncode(widget._signalData))['content']
        ['signals'] as List;

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
                        jsonDecode(jsonEncode(widget._signalData))['title'])),
              );
            },
            child: ProductHeader(
                jsonDecode(jsonEncode(widget._signalData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                              builder: (context) => CompanyPage(
                                _signals[index]['companyId'],
                                4,
                                ticker: _signals[index]['ticker'],
                                companyName: _signals[index]['companyName'],
                              ),
                            ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_signals[index]['ticker'],
                              style: getBoldTextStyle()),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            _signals[index]['data'],
                            style: getDescriptionTextStyle(),
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
