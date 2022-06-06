class Favorites {
  Favorites({
    required this.companyName,
    required this.companyId,
    required this.ticker,
    this.note,
    this.noteTimestamp,
  });

  final String companyName;
  final int companyId;
  final String ticker;
  String? note = "";
  String? noteTimestamp = "";

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        companyName: json["companyName"],
        companyId: json["companyId"],
        ticker: json["ticker"],
        note: json["note"],
        noteTimestamp: json["noteTimestamp"],
      );

  // Map<String, dynamic> toJson() => {
  //       "video": video.toJson(),
  //     };
}
