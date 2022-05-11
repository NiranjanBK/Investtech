// To parse this JSON data, do
//
//     final evaluation = evaluationFromJson(jsonString);

import 'dart:convert';

class Evaluation {
  Evaluation(
      {required this.title, this.evaluation, this.analysesDate, this.content});

  String? analysesDate;
  Title title;
  List<Title>? evaluation;
  List<Title>? content;

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        title: Title.fromJson(json["title"]),
        analysesDate: json["analysesDate"],
        evaluation: json["evaluation"] == null
            ? null
            : List<Title>.from(
                json["evaluation"].map((x) => Title.fromJson(x))),
        content: json["content"] == null
            ? null
            : List<Title>.from(json["content"].map((x) => Title.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "evaluation": evaluation == null
            ? null
            : List<dynamic>.from(evaluation!.map((x) => x.toJson())),
      };
}

class Title {
  Title({
    required this.companyId,
    required this.index,
    required this.ticker,
    required this.close,
    required this.change,
    required this.short,
    required this.medium,
    required this.long,
  });

  String companyId;
  String index;
  String ticker;
  String close;
  String change;
  String short;
  String medium;
  String long;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        companyId: json["companyId"],
        index: json["index"],
        ticker: json["ticker"],
        close: json["close"],
        change: json["change"],
        short: json["short"],
        medium: json["medium"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "index": index,
        "ticker": ticker,
        "close": close,
        "change": change,
        "short": short,
        "medium": medium,
        "long": long,
      };
}
