// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_commentary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketCommentary _$MarketCommentaryFromJson(Map<String, dynamic> json) =>
    MarketCommentary(
      market: json['market'] as String,
      companyName: json['companyName'] as String,
      ticker: json['ticker'] as String,
      changePct: json['changePct'] as String,
      close: json['close'] as String,
      companyId: json['companyId'] as String,
      evaluationCode: json['evaluationCode'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$MarketCommentaryToJson(MarketCommentary instance) =>
    <String, dynamic>{
      'market': instance.market,
      'companyName': instance.companyName,
      'ticker': instance.ticker,
      'close': instance.close,
      'changePct': instance.changePct,
      'companyId': instance.companyId,
      'evaluationCode': instance.evaluationCode,
      'title': instance.title,
    };
