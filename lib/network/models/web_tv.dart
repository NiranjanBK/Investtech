// To parse this JSON data, do
//
//     final webTv = webTvFromJson(jsonString);

// To parse this JSON data, do
//
//     final webTv = webTvFromJson(jsonString);

import 'dart:convert';

class WebTv {
  WebTv({
    required this.video,
  });

  Video video;

  factory WebTv.fromJson(Map<String, dynamic> json) => WebTv(
        video: Video.fromJson(json["video"]),
      );

  Map<String, dynamic> toJson() => {
        "video": video.toJson(),
      };
}

class Video {
  Video({
    required this.youtubeId,
    required this.title,
    required this.description,
    required this.viewCount,
    required this.duration,
    required this.timestamp,
  });

  String youtubeId;
  String title;
  String description;
  String viewCount;
  String duration;
  DateTime timestamp;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        youtubeId: json["youtubeId"],
        title: json["title"],
        description: json["description"],
        viewCount: json["viewCount"],
        duration: json["duration"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "youtubeId": youtubeId,
        "title": title,
        "description": description,
        "viewCount": viewCount,
        "duration": duration,
        "timestamp": timestamp.toIso8601String(),
      };
}
