// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top20.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Top20 _$Top20FromJson(Map<String, dynamic> json) => Top20(
      price: json['price'] as String,
      companyName: json['companyName'] as String,
      ticker: json['ticker'] as String,
      changePct: json['changePct'] as String,
      changeVal: json['changeVal'] as String,
      companyId: json['companyId'] as String,
      techScoreMedium: json['techScoreMedium'] as String,
    );

Map<String, dynamic> _$Top20ToJson(Top20 instance) => <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'ticker': instance.ticker,
      'price': instance.price,
      'changePct': instance.changePct,
      'changeVal': instance.changeVal,
      'techScoreMedium': instance.techScoreMedium,
    };
