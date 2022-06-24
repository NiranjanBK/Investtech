import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/evaluation.dart' as title;

class IndicesList extends StatelessWidget {
  final List<title.Title> _indicesEvaluation;
  final int itemCount;
  String? page;

  IndicesList(this._indicesEvaluation, this.itemCount, {Key? key, this.page})
      : super(key: key);

  displayArrow(int evalCode) {
    if (evalCode > 0) {
      return Image.asset(
        'assets/images/arrow_green_small.gif',
        width: 20,
        height: 20,
      );
    } else if (evalCode == 0) {
      return Image.asset(
        'assets/images/arrow_yellow_small.gif',
        width: 20,
        height: 20,
      );
    } else {
      return Image.asset(
        'assets/images/arrow_red_small.gif',
        width: 20,
        height: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: itemCount,
      itemBuilder: (ctx, index) {
        return Table(
          children: [
            TableRow(children: [
              if (page == 'detail') ...{
                Text(
                  _indicesEvaluation[index].ticker,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                Text(
                  double.parse(
                    _indicesEvaluation[index].close,
                  ).toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                Text(
                  double.parse(_indicesEvaluation[index].change)
                      .toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                displayArrow(
                  int.parse(_indicesEvaluation[index].short),
                ),
                displayArrow(int.parse(_indicesEvaluation[index].medium)),
                displayArrow(int.parse(_indicesEvaluation[index].long)),
              } else ...{
                Text(_indicesEvaluation[index].ticker),
                displayArrow(int.parse(_indicesEvaluation[index].short)),
                displayArrow(int.parse(_indicesEvaluation[index].medium)),
                displayArrow(int.parse(_indicesEvaluation[index].long)),
              }
            ])
          ],
        );
      },
    );
  }
}
