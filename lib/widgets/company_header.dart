import 'package:flutter/material.dart';

class CompanyHeader extends StatelessWidget {
  final String ticker, companyName, close, changePct, changeValue, evaluation;
  final String? formattedDate, market, term, evalCode, priceDate, showDate;

  // ignore: use_key_in_widget_constructors
  const CompanyHeader(
      {required this.ticker,
      required this.companyName,
      required this.changePct,
      required this.changeValue,
      required this.close,
      required this.evaluation,
      this.market,
      this.term,
      this.formattedDate,
      this.evalCode,
      this.priceDate,
      this.showDate});

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
    var date = formattedDate ?? priceDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${companyName} (${ticker})',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Text(
              '${double.parse(close)}',
              style: TextStyle(color: Colors.grey[700], fontSize: 10),
            ),
            Text(
              ' (${double.parse(changePct)}%)',
              style: TextStyle(
                  color: double.parse(changePct) > 0.0
                      ? Colors.green[900]
                      : Colors.red[900],
                  fontSize: 10),
            ),
            Text(showDate == null ? '' : ', ${date.toString()} ',
                style: TextStyle(color: Colors.grey[700], fontSize: 10)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Advanced Technical Analysis',
                  style: TextStyle(color: Colors.grey[700], fontSize: 10),
                ),
                Text(
                  term.toString(),
                  style: TextStyle(color: Colors.grey[700], fontSize: 10),
                ),
                Text(
                  'Recommendaton one to six months',
                  style: TextStyle(color: Colors.grey[700], fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 2),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    color: getBoarderColor(int.parse(evalCode!)), width: 7),
              )),
              child: Text(
                evaluation.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 16),
              ),
            )
          ],
        ),
      ],
    );
  }
}
