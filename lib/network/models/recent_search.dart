class RecentSearch {
  RecentSearch({
    required this.ticker,
    required this.companyId,
    required this.countryCode,
    required this.companyName,
    this.timestamp,
  });

  final String companyName;
  final String companyId;
  final String ticker;
  String countryCode;
  String? timestamp = "";

  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
        ticker: json["ticker"],
        companyId: json["companyId"],
        countryCode: json["countryCode"],
        companyName: json["companyName"],
        timestamp: json["timestamp"],
      );

  // Map<String, dynamic> toJson() => {
  //       "video": video.toJson(),
  //     };
}
