import 'package:json_annotation/json_annotation.dart';

part 'market_commentary.g.dart';

@JsonSerializable()
class MarketCommentary {
  final String market;
  final String companyName;
  final String ticker;
  final String close;
  final String changePct;
  final String companyId;
  final String evaluationCode;
  final String title;

  MarketCommentary({
    required this.market,
    required this.companyName,
    required this.ticker,
    required this.changePct,
    required this.close,
    required this.companyId,
    required this.evaluationCode,
    required this.title,
  });

  factory MarketCommentary.fromJson(dynamic json) =>
      _$MarketCommentaryFromJson(json);

  // Map<String, dynamic> toJson() => _$MarketCommentaryToJson(this);
}
