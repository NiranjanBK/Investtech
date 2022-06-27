import 'package:flutter/material.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChartView extends StatelessWidget {
  final String cmpId;
  final int chartId;
  final String companyName;
  final String ticker;
  final String priceDate;
  final String close;
  final String changePct;

  const ChartView(this.cmpId, this.chartId, this.companyName, this.ticker,
      this.priceDate, this.close, this.changePct,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '${companyName} (${ticker})',
        style: getNameAndTickerTextStyle(),
      ),
      Row(
        children: [
          Text(
            '${double.parse(close)}',
            style: getSmallBoldTextStyle(),
          ),
          Text(
            ' (${double.parse(changePct)}%), ',
            style: TextStyle(
                color: double.parse(changePct) > 0.0
                    ? Colors.green[900]
                    : Colors.red[900],
                fontSize: 12),
          ),
          Text(priceDate.toString(), style: getSmallTextStyle()),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        child: CachedNetworkImage(
          imageUrl: ApiRepo()
              .getChartUrl(CHART_TYPE_ADVANCED, 4, CHART_STYLE_NORMAL, cmpId),
          placeholder: (context, url) => Container(
              height: 275,
              width: double.infinity,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Color(ColorHex.ACCENT_COLOR),
              ))),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        // Image.network(ApiRepo()
        //     .getChartUrl(CHART_TYPE_ADVANCED, 4, CHART_STYLE_NORMAL, cmpId)),
      ),
    ]);
  }
}
