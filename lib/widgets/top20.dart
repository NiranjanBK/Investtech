import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:investtech_app/ui/top20_list_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import 'package:investtech_app/widgets/top20_list.dart';
import '../network/models/top20.dart';

class TopTwenty extends StatelessWidget {
  final dynamic _top20Data;

  TopTwenty(this._top20Data);

  @override
  Widget build(BuildContext context) {
    var _top20Companies =
        jsonDecode(jsonEncode(_top20Data))['content']['company'] as List;
    List<Top20> top20Obj =
        _top20Companies.map((top20Json) => Top20.fromJson(top20Json)).toList();

    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Top20ListPage(
                        jsonDecode(jsonEncode(_top20Data))['title'])),
              );
            },
            child:
                ProductHeader(jsonDecode(jsonEncode(_top20Data))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Top20List(top20Obj),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
