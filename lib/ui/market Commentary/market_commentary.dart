import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/market%20Commentary/mc_main.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../../network/models/market_commentary.dart';

class MarketCommentaries extends StatelessWidget {
  final dynamic _marketData;

  MarketCommentaries(this._marketData);

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: commentaryObj.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                //childAspectRatio: 0.9,
                //crossAxisSpacing: 1.0,
              ),
              itemBuilder: (ctx, index) {
                Color? cardBackground =
                    BlocProvider.of<ThemeBloc>(context).loadTheme ==
                            AppTheme.darkTheme
                        ? Theme.of(context).primaryColor
                        : ColorHex()
                            .getBoarderColor(
                                int.parse(commentaryObj[index].evaluationCode))
                            .withAlpha(0x1A);
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
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Container(
                            height: 10,
                            // margin: EdgeInsets.only(top: 5),
                            color: ColorHex().getBoarderColor(int.parse(
                                commentaryObj[index].evaluationCode))),
                        Expanded(
                          child: Container(
                            color: cardBackground,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commentaryObj[index].market,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  double.parse((commentaryObj[index].close))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${double.parse((commentaryObj[index].changePct)).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: double.parse((commentaryObj[index]
                                                  .changePct)) >
                                              0
                                          ? const Color(ColorHex.green)
                                          : const Color(ColorHex.red)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  commentaryObj[index].title,
                                  style: const TextStyle(
                                    fontSize: 14,
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
