import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/models/company.dart';

class CompanyPriceQuote extends StatelessWidget {
  final Company cmpData;
  final bool subscribedUser;
  CompanyPriceQuote(this.cmpData, this.subscribedUser, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cmpData.name.toString()} (${cmpData.ticker})',
          style: getNameAndTickerTextStyle(),
        ),
        Row(
          children: [
            Text(
              '${double.parse(cmpData.closePrice.toString())}',
              style: getSmallBoldTextStyle(),
            ),
            Text(
              ' (${double.parse(cmpData.changePct)}%)',
              style: TextStyle(
                  color: double.parse(cmpData.changePct) > 0.0
                      ? const Color(ColorHex.green)
                      : const Color(ColorHex.red),
                  fontSize: 12),
            ),
            Text(' ${cmpData.priceDate.toString()} ',
                style: getSmallTextStyle()),
          ],
        ),
      ],
    );
  }
}
