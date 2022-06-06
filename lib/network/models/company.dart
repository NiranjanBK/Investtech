import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  final String? companyId;
  final String ticker;
  final String? close;
  final String changePct;
  final String? changeValue;
  final String? changeVal;
  final String? companyName;
  final String? assetName;
  final String? marketCode;
  final String? imagePath;
  final String? term;
  final String? evaluation;
  final String? evaluationCode;
  final String? commentary;
  final String? text;
  final String? evaluationText;
  final String? techScore,
      Name,
      name,
      Id,
      countryCode,
      closePrice,
      closeText,
      marketName,
      priceDate,
      commentText,
      autoComment,
      change,
      formattedDate;

  Company(
      {this.close,
      required this.ticker,
      required this.changePct,
      this.changeValue,
      this.Name,
      this.name,
      this.Id,
      this.countryCode,
      this.companyId,
      this.changeVal,
      this.companyName,
      this.marketCode,
      this.imagePath,
      this.evaluation,
      this.evaluationCode,
      this.commentary,
      this.term,
      this.assetName,
      this.evaluationText,
      this.techScore,
      this.text,
      this.autoComment,
      this.closePrice,
      this.closeText,
      this.commentText,
      this.marketName,
      this.priceDate,
      this.change,
      this.formattedDate});

  factory Company.fromJson(dynamic json) => _$CompanyFromJson(json);

  //Map<String, dynamic> toJson() => _$Top20ToJson(this);
}
