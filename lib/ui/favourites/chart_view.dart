import 'package:flutter/material.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartView extends StatefulWidget {
  final String cmpId;
  final int chartId;
  final String companyName;
  final String ticker;
  final String priceDate;
  final String close;
  final String changePct;
  final bool hasAdvancedChartSubscription;

  const ChartView(
      this.cmpId,
      this.chartId,
      this.companyName,
      this.ticker,
      this.priceDate,
      this.close,
      this.changePct,
      this.hasAdvancedChartSubscription,
      {Key? key})
      : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  ThemeBloc? bloc;

  @override
  void initState() {
    // TODO: implement initState

    bloc = context.read<ThemeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '${widget.companyName} (${widget.ticker})',
        style: getNameAndTickerTextStyle(),
      ),
      Row(
        children: [
          Text(
            '${double.parse(widget.close)}',
            style: getSmallBoldTextStyle(),
          ),
          Text(
            ' (${double.parse(widget.changePct)}%), ',
            style: TextStyle(
                color: double.parse(widget.changePct) > 0.0
                    ? const Color(ColorHex.green)
                    : const Color(ColorHex.red),
                fontSize: 12),
          ),
          Text(widget.priceDate.toString(), style: getSmallTextStyle()),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        child: CachedNetworkImage(
          imageUrl: ApiRepo().getChartUrl(
              widget.hasAdvancedChartSubscription
                  ? CHART_TYPE_ADVANCED
                  : CHART_TYPE_FREE,
              4,
              bloc!.loadTheme == AppTheme.lightTheme
                  ? CHART_STYLE_NORMAL
                  : CHART_STYLE_BLACK,
              widget.cmpId),
          placeholder: (context, url) => Container(
              height: 275,
              width: double.infinity,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Color(ColorHex.ACCENT_COLOR),
              ))),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        // Image.network(ApiRepo()
        //     .getChartUrl(CHART_TYPE_ADVANCED, 4, CHART_STYLE_NORMAL, cmpId)),
      ),
    ]);
  }
}
