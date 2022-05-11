import 'package:json_annotation/json_annotation.dart';

part 'top20.g.dart';

@JsonSerializable()
class Top20 {
  final String companyId;
  final String companyName;
  final String ticker;
  final String price;
  final String changePct;
  final String changeVal;
  final String techScoreMedium;

  Top20({
    required this.price,
    required this.companyName,
    required this.ticker,
    required this.changePct,
    required this.changeVal,
    required this.companyId,
    required this.techScoreMedium,
  });

  factory Top20.fromJson(dynamic json) => _$Top20FromJson(json);

  //Map<String, dynamic> toJson() => _$Top20ToJson(this);
}
