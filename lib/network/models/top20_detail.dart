import 'package:investtech_app/network/models/top20.dart';
import 'package:json_annotation/json_annotation.dart';

part 'top20_detail.g.dart';

@JsonSerializable()
class Top20Detail {
  Top20Detail({
    required this.company,
    required this.analysesDate,
  });

  List<Top20> company;
  String analysesDate;

  factory Top20Detail.fromJson(Map<String, dynamic> json) => Top20Detail(
        company:
            List<Top20>.from(json["company"].map((x) => Top20.fromJson(x))),
        analysesDate: json["analysesDate"],
      );

  // Map<String, dynamic> toJson() => {
  //    "company": List<dynamic>.from(company.map((x) => x.toJson())),
  //   "analysesDate": analysesDate,
  //};
}
