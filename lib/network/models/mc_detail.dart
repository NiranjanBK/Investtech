// To parse this JSON data, do
//
//     final marketCommentaryDetail = marketCommentaryDetailFromJson(jsonString);

import 'dart:convert';

MarketCommentaryDetail marketCommentaryDetailFromJson(String str) =>
    MarketCommentaryDetail.fromJson(json.decode(str));

String marketCommentaryDetailToJson(MarketCommentaryDetail data) =>
    json.encode(data.toJson());

class MarketCommentaryDetail {
  MarketCommentaryDetail({
    required this.marketCommentary,
    this.analysesDate,
  });

  List<MarketCommentary> marketCommentary;
  String? analysesDate;

  factory MarketCommentaryDetail.fromJson(Map<String, dynamic> json) =>
      MarketCommentaryDetail(
        marketCommentary: List<MarketCommentary>.from(
            json["marketCommentary"].map((x) => MarketCommentary.fromJson(x))),
        analysesDate: json["analysesDate"],
      );

  Map<String, dynamic> toJson() => {
        "marketCommentary":
            List<dynamic>.from(marketCommentary.map((x) => x.toJson())),
        "analysesDate": analysesDate,
      };
}

class MarketCommentary {
  MarketCommentary({
    this.analyze,
  });

  Analyze? analyze;

  factory MarketCommentary.fromJson(Map<String, dynamic> json) =>
      MarketCommentary(
        analyze: Analyze.fromJson(json["analyze"]),
      );

  Map<String, dynamic> toJson() => {
        "analyze": analyze!.toJson(),
      };
}

class Analyze {
  Analyze({
    this.market,
    this.date,
    this.title,
    this.ingress,
    this.stocks,
    this.marketInfo,
  });

  String? market;
  String? date;
  String? title;
  Ingress? ingress;
  AnalyzeStocks? stocks;
  MarketInfo? marketInfo;

  factory Analyze.fromJson(Map<String, dynamic> json) => Analyze(
        market: json["market"],
        date: json["date"],
        title: json["title"],
        ingress: Ingress.fromJson(json["ingress"]),
        stocks: AnalyzeStocks.fromJson(json["stocks"]),
        marketInfo: MarketInfo.fromJson(json["marketInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "market": market,
        "date": date,
        "title": title,
        "ingress": ingress!.toJson(),
        "stocks": stocks!.toJson(),
        "marketInfo": marketInfo!.toJson(),
      };
}

class Ingress {
  Ingress({
    this.ticker,
    this.companyId,
    this.companyName,
    this.text,
  });

  String? ticker;
  String? companyId;
  String? companyName;
  String? text;

  factory Ingress.fromJson(Map<String, dynamic> json) => Ingress(
        ticker: json["ticker"],
        companyId: json["companyId"],
        companyName: json["companyName"],
        text: json["text"] == null ? null : json["text"],
      );

  Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "companyId": companyId,
        "companyName": companyName,
        "text": text == null ? null : text,
      };
}

class MarketInfo {
  MarketInfo({
    this.numUpDown,
    this.winnersAndLosers,
    this.mostActive,
    this.totalTurnOver,
  });

  String? numUpDown;
  MostActive? winnersAndLosers;
  MostActive? mostActive;
  String? totalTurnOver;

  factory MarketInfo.fromJson(Map<String, dynamic> json) => MarketInfo(
        numUpDown: json["numUpDown"],
        winnersAndLosers: MostActive.fromJson(json["winnersAndLosers"]),
        mostActive: MostActive.fromJson(json["mostActive"]),
        totalTurnOver: json["totalTurnOver"],
      );

  Map<String, dynamic> toJson() => {
        "numUpDown": numUpDown,
        "winnersAndLosers": winnersAndLosers!.toJson(),
        "mostActive": mostActive!.toJson(),
        "totalTurnOver": totalTurnOver,
      };
}

class MostActive {
  MostActive({
    this.text,
    this.stocks,
  });

  String? text;
  MostActiveStocks? stocks;

  factory MostActive.fromJson(Map<String, dynamic> json) => MostActive(
        text: json["text"],
        stocks: MostActiveStocks.fromJson(json["stocks"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "stocks": stocks!.toJson(),
      };
}

class MostActiveStocks {
  MostActiveStocks({
    required this.stock,
  });

  List<Stock> stock;

  factory MostActiveStocks.fromJson(Map<String, dynamic> json) =>
      MostActiveStocks(
        stock: List<Stock>.from(json["stock"].map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stock": List<dynamic>.from(stock.map((x) => x.toJson())),
      };
}

class Stock {
  Stock({
    this.attributes,
  });

  Ingress? attributes;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        attributes: Ingress.fromJson(json["@attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "@attributes": attributes!.toJson(),
      };
}

class AnalyzeStocks {
  AnalyzeStocks({
    required this.stock,
    this.sectorComment,
  });

  List<Ingress> stock;
  String? sectorComment;

  factory AnalyzeStocks.fromJson(Map<String, dynamic> json) => AnalyzeStocks(
        stock:
            List<Ingress>.from(json["stock"].map((x) => Ingress.fromJson(x))),
        sectorComment:
            json["sectorComment"] == null ? null : json["sectorComment"],
      );

  Map<String, dynamic> toJson() => {
        "stock": List<dynamic>.from(stock.map((x) => x.toJson())),
        "sectorComment": sectorComment == null ? null : sectorComment,
      };
}
