import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/barometer.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarometerGraph extends StatefulWidget {
  final dynamic _barometerData;
  final String title;
  // ignore: prefer_const_constructors_in_immutables
  BarometerGraph(
    this._barometerData,
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  BarometerGraphState createState() => BarometerGraphState();
}

class BarometerGraphState extends State<BarometerGraph> {
  //late List<_ChartData> data;
  //late TooltipBehavior _tooltip;

  @override
  Widget build(BuildContext context) {
    Barometer _barometer = Barometer.fromJson(widget._barometerData);
    var totalStocks = int.parse(_barometer.stockBarometer.buy) +
        int.parse(_barometer.stockBarometer.sell) +
        int.parse(_barometer.stockBarometer.watch);

    var buyPct = int.parse(_barometer.stockBarometer.buy) / totalStocks * 100;
    var sellPct = int.parse(_barometer.stockBarometer.sell) / totalStocks * 100;
    var watchPct =
        int.parse(_barometer.stockBarometer.watch) / totalStocks * 100;

    final List<ChartData> chartData = [
      ChartData(
          _barometer.stockBarometer.legendBuy, buyPct, (Colors.green[400])!),
      ChartData(_barometer.stockBarometer.legendWatch, watchPct,
          (Colors.yellow[400])!),
      ChartData(
          _barometer.stockBarometer.legendSell, sellPct, (Colors.red[400])!),
    ];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            ProductHeader('', 0),
            const SizedBox(
              height: 10,
            ),
            Text(
              _barometer.stockBarometer.market,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: SfCircularChart(
                series: <CircularSeries>[
                  // Renders doughnut chart
                  DoughnutSeries<ChartData, String>(
                      onPointTap: (ChartPointDetails details) {},
                      explode: true,
                      innerRadius: '20.0',
                      radius: '70',
                      dataLabelMapper: (ChartData data, _) =>
                          '${data.y.toStringAsFixed(1)} %\n${data.x}',
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ],
                centerX: '50%',
                centerY: '50%',
                margin: const EdgeInsets.all(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
