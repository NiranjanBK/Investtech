// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      close: json['close'] as String?,
      ticker: json['ticker'] as String,
      changePct: json['changePct'] as String,
      changeValue: json['changeValue'] as String?,
      companyId: json['companyId'] as String,
      changeVal: json['changeVal'] as String?,
      companyName: json['companyName'] as String?,
      marketCode: json['marketCode'] as String?,
      imagePath: json['imagePath'] as String?,
      evaluation: json['evaluation'] as String?,
      evaluationCode: json['evaluationCode'] as String?,
      commentary: json['commentary'] as String?,
      term: json['term'] as String?,
      assetName: json['assetName'] as String?,
      evaluationText: json['evaluationText'] as String?,
      techScore: json['techScore'] as String?,
      text: json['text'] as String?,
      autoComment: json['autoComment'] as String?,
      closePrice: json['closePrice'] as String?,
      closeText: json['closeText'] as String?,
      commentText: json['commentText'] as String?,
      marketName: json['marketName'] as String?,
      name: json['name'] as String?,
      priceDate: json['priceDate'] as String?,
      change: json['change'] as String?,
      formattedDate: json['formattedDate'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'companyId': instance.companyId,
      'ticker': instance.ticker,
      'close': instance.close,
      'changePct': instance.changePct,
      'changeValue': instance.changeValue,
      'changeVal': instance.changeVal,
      'companyName': instance.companyName,
      'assetName': instance.assetName,
      'marketCode': instance.marketCode,
      'imagePath': instance.imagePath,
      'term': instance.term,
      'evaluation': instance.evaluation,
      'evaluationCode': instance.evaluationCode,
      'commentary': instance.commentary,
      'text': instance.text,
      'evaluationText': instance.evaluationText,
      'techScore': instance.techScore,
      'name': instance.name,
      'closePrice': instance.closePrice,
      'closeText': instance.closeText,
      'marketName': instance.marketName,
      'priceDate': instance.priceDate,
      'commentText': instance.commentText,
      'autoComment': instance.autoComment,
      'change': instance.change,
    };
