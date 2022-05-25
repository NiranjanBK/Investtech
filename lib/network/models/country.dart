class COUNTRY {
  final int id;
  final int countryId;
  final String defalutLang;
  final String countryName;
  final String countryCode;
  final String appleCountryCode;
  final String defalutMarketCode;

  const COUNTRY({
    required this.id,
    required this.countryId,
    required this.defalutLang,
    required this.countryName,
    required this.countryCode,
    required this.appleCountryCode,
    required this.defalutMarketCode,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'countryId': countryId,
      'defalutLang': defalutLang,
      'countryName': countryName,
      'countryCode': countryCode,
      'appleCountryCode': appleCountryCode,
      'defalutMarketCode': defalutMarketCode,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  //@override
  // String toString() {
  //   return 'Dog{id: $id, name: $name, age: $age}';
  // }
}
