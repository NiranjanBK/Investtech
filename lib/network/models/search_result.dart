// To parse this JSON data, do
//
//     final searchResult = searchResultFromJson(jsonString);

import 'dart:convert';

List<SearchResult> searchResultFromJson(String str) => List<SearchResult>.from(
    json.decode(str).map((x) => SearchResult.fromJson(x)));

String searchResultToJson(List<SearchResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchResult {
  SearchResult({
    required this.ticker,
    required this.companyId,
    required this.countryCode,
    required this.companyName,
    required this.currency,
    required this.lastClose,
    required this.changePct,
    required this.changeVal,
  });

  String ticker;
  String companyId;
  String countryCode;
  String companyName;
  String currency;
  String lastClose;
  String changePct;
  String changeVal;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        ticker: json["ticker"],
        companyId: json["companyId"],
        countryCode: json["countryCode"],
        companyName: json["companyName"],
        currency: json["currency"],
        lastClose: json["lastClose"],
        changePct: json["changePct"],
        changeVal: json["changeVal"],
      );

  Map<String, dynamic> toJson() => {
        "ticker": ticker,
        "companyId": companyId,
        "countryCode": countryCode,
        "companyName": companyName,
        "currency": currency,
        "lastClose": lastClose,
        "changePct": changePct,
        "changeVal": changeVal,
      };
}
