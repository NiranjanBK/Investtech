class MARKET {
  final int marketId;
  final String marketCode;
  final String marketName;
  final int countryId;
  final String externalCode;
  final String currencyCode;
  final int prefernce;

  const MARKET({
    required this.marketId,
    required this.marketCode,
    required this.marketName,
    required this.countryId,
    required this.externalCode,
    required this.currencyCode,
    required this.prefernce,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'marketId': marketId,
      'marketCode': marketCode,
      'marketName': marketName,
      'countryId': countryId,
      'externalCode': externalCode,
      'currencyCode': currencyCode,
      'prefernce': prefernce,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  //@override
  // String toString() {
  //   return 'Dog{id: $id, name: $name, age: $age}';
  // }
}
