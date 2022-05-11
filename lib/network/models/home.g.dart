// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Home _$HomeFromJson(Map<String, dynamic> json) => Home(
      analysesDate: json['analysesDate'] as String,
      teaser: (json['teaser'] as List<dynamic>)
          .map((e) => Teaser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeToJson(Home instance) => <String, dynamic>{
      'analysesDate': instance.analysesDate,
      'teaser': instance.teaser.map((e) => e.toJson()).toList(),
    };

Teaser _$TeaserFromJson(Map<String, dynamic> json) => Teaser(
      json['id'] as String,
      json['productName'] as String,
      json['title'] as String,
      json['content'] as Map<String, dynamic>,
    )..isIncluded = json['isIncluded'] as bool?;

Map<String, dynamic> _$TeaserToJson(Teaser instance) => <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'title': instance.title,
      'content': instance.content,
      'isIncluded': instance.isIncluded,
    };
