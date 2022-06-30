class MARKET {
  final int marketId;
  final String marketCode;
  final String marketName;
  final int countryId;
  final String countryCode;
  final String countryName;

  const MARKET({
    required this.marketId,
    required this.marketCode,
    required this.marketName,
    required this.countryId,
    required this.countryCode,
    required this.countryName,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'marketId': marketId,
      'marketCode': marketCode,
      'marketName': marketName,
      'countryId': countryId,
      'countryCode': countryCode,
      'countryName': countryName,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  //@override
  // String toString() {
  //   return 'Dog{id: $id, name: $name, age: $age}';
  // }
}
