// To parse this JSON data, do
//
//     final barometer = barometerFromJson(jsonString);

import 'dart:convert';

Barometer barometerFromJson(String str) => Barometer.fromJson(json.decode(str));

String barometerToJson(Barometer data) => json.encode(data.toJson());

class Barometer {
  Barometer({
    required this.stockBarometer,
  });

  StockBarometer stockBarometer;

  factory Barometer.fromJson(Map<String, dynamic> json) => Barometer(
        stockBarometer: StockBarometer.fromJson(json["stockBarometer"]),
      );

  Map<String, dynamic> toJson() => {
        "stockBarometer": stockBarometer.toJson(),
      };
}

class StockBarometer {
  StockBarometer({
    required this.market,
    required this.buy,
    required this.watch,
    required this.sell,
    required this.legendBuy,
    required this.legendSell,
    required this.legendWatch,
  });

  String market;
  String buy;
  String watch;
  String sell;
  String legendBuy;
  String legendSell;
  String legendWatch;

  factory StockBarometer.fromJson(Map<String, dynamic> json) => StockBarometer(
        market: json["market"],
        buy: json["buy"],
        watch: json["watch"],
        sell: json["sell"],
        legendBuy: json["legendBuy"],
        legendSell: json["legendSell"],
        legendWatch: json["legendWatch"],
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "buy": buy,
        "watch": watch,
        "sell": sell,
        "legendBuy": legendBuy,
        "legendSell": legendSell,
        "legendWatch": legendWatch,
      };
}
