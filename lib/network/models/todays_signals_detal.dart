// To parse this JSON data, do
//
//     final todaysSignalDetail = todaysSignalDetailFromJson(jsonString);

import 'dart:convert';

class TodaysSignalDetail {
  TodaysSignalDetail({
    required this.header,
    required this.signalList,
    required this.analysesDate,
  });

  String header;
  SignalList signalList;
  String analysesDate;

  factory TodaysSignalDetail.fromJson(Map<String, dynamic> json) =>
      TodaysSignalDetail(
        header: json["header"],
        signalList: SignalList.fromJson(json["signalList"]),
        analysesDate: json["analysesDate"],
      );

  Map<String, dynamic> toJson() => {
        "header": header,
        "signalList": signalList.toJson(),
        "analysesDate": analysesDate,
      };
}

class SignalList {
  SignalList({
    required this.signal,
  });

  List<Signal> signal;

  factory SignalList.fromJson(Map<String, dynamic> json) => SignalList(
        signal:
            List<Signal>.from(json["signal"].map((x) => Signal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "signal": List<dynamic>.from(signal.map((x) => x.toJson())),
      };
}

class Signal {
  Signal({
    required this.companyId,
    required this.companyName,
    required this.ticker,
    required this.evaluation,
    required this.data,
  });

  String companyId;
  String companyName;
  String ticker;
  String evaluation;
  String data;

  factory Signal.fromJson(Map<String, dynamic> json) => Signal(
        companyId: json["companyId"],
        companyName: json["companyName"],
        ticker: json["ticker"],
        evaluation: json["evaluation"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "companyName": companyName,
        "ticker": ticker,
        "evaluation": evaluation,
        "data": data,
      };
}
