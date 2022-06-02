import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:investtech_app/ui/mc_main.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../network/models/market_commentary.dart';

class MarketCommentaries extends StatelessWidget {
  final dynamic _marketData;

  MarketCommentaries(this._marketData);

  getBoarderColor(int evalCode) {
    if (evalCode > 0) {
      return Colors.green[900];
    } else if (evalCode == 0) {
      return Colors.yellow[400];
    } else {
      return Colors.red[900];
    }
  }

  @override
  Widget build(BuildContext context) {
    var _marketCommentaries = jsonDecode(jsonEncode(_marketData))['content']
        ['marketCommentary'] as List;

    List<MarketCommentary> commentaryObj = _marketCommentaries
        .map((commentaryJson) => MarketCommentary.fromJson(commentaryJson))
        .toList();

    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MarketCommentaryMain(
                        jsonDecode(jsonEncode(_marketData))['title'])),
              );
            },
            child:
                ProductHeader(jsonDecode(jsonEncode(_marketData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: commentaryObj.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                //crossAxisSpacing: 1.0,
              ),
              itemBuilder: (ctx, index) {
                Color? cardBackground =
                    double.parse((commentaryObj[index].evaluationCode)) > 0
                        ? Colors.green[50]
                        : double.parse((commentaryObj[index].evaluationCode)) == 0
                        ? Colors.orange[50] Colors.red[100];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketCommentaryMain(
                          jsonDecode(jsonEncode(_marketData))['title'],
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                            height: 10,
                            // margin: EdgeInsets.only(top: 5),
                            color: getBoarderColor(
                                int.parse(commentaryObj[index].evaluationCode))),
                        Expanded(
                          child: Container(
                            color: cardBackground,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commentaryObj[index].market,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  double.parse((commentaryObj[index].close))
                                      .toStringAsFixed(2),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height:2),
                                Text(
                                  '${double.parse((commentaryObj[index].changePct)).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                      color: double.parse((commentaryObj[index]
                                                  .changePct)) >
                                              0
                                          ? Colors.green[900]
                                          : Colors.red[900]),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  commentaryObj[index].title,
                                  style: const TextStyle(
                                    fontSize: 12,
                                 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
