import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import './market_commentary.dart';

part 'home.g.dart';

@JsonSerializable(explicitToJson: true)
class Home {
  final String analysesDate;
  final List<Teaser> teaser;

  Home({
    required this.analysesDate,
    required this.teaser,
  });

  factory Home.fromJson(Map<String, dynamic> json) => _$HomeFromJson(json);

  Map<String, dynamic> toJson() => _$HomeToJson(this);
}

@JsonSerializable()
class Teaser {
  final String id, productName, title;
  final Map<String, dynamic> content;
  bool? isIncluded;

  Teaser(this.id, this.productName, this.title, this.content);

  factory Teaser.fromJson(Map<String, dynamic> json) => _$TeaserFromJson(json);

  Map<String, dynamic> toJson() => _$TeaserToJson(this);
}

/*
@JsonSerializable()
class Content {
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}*/
