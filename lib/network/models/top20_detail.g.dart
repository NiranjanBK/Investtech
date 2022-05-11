// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top20_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Top20Detail _$Top20DetailFromJson(Map<String, dynamic> json) => Top20Detail(
      company: (json['company'] as List<dynamic>)
          .map((e) => Top20.fromJson(e))
          .toList(),
      analysesDate: json['analysesDate'] as String,
    );

Map<String, dynamic> _$Top20DetailToJson(Top20Detail instance) =>
    <String, dynamic>{
      'company': instance.company,
      'analysesDate': instance.analysesDate,
    };
