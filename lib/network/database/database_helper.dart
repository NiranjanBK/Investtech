import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investtech_app/network/models/country.dart';
import 'package:investtech_app/network/models/market.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String countryTable = "COUNTRY";
  static const String id = '_id';
  static const String countryId = "COUNTRY_ID";
  static const String defalutLang = "DEFAULT_LANGUAGE_ID";
  static const String countryName = "COUNTRY_NAME";
  static const String countryCode = "COUNTRY_CODE";
  static const String appleCountryCode = "APPLE_COUNTRY_CODE";
  static const String defalutMarketCode = "DEFAULT_MARKET_CODE";

  static const String marketTable = "MARKET";
  static const String marketId = "MARKET_ID";
  static const String marketCode = "MARKET_CODE";
  static const String marketName = "MARKET_NAME";
  static const String externalCode = "EXTERNAL_CODE";
  static const String currencyCode = "CURRENCY_CODE";
  static const String prefernce = "PREFERENCE";

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "investtech.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "db/investtech.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: true);
  }

  Future<List<COUNTRY>> getCountryDetails() async {
    final database = await db;
    final List<Map<String, dynamic>> res = await database!.rawQuery(
      "SELECT * FROM $countryTable ",
    );

    return List.generate(res.length, (index) {
      return COUNTRY(
        id: int.tryParse(res[index][id].toString()) ?? -1,
        countryId: int.tryParse(res[index][countryId].toString()) ?? -1,
        defalutLang: res[index][defalutLang],
        countryName: res[index][countryName],
        countryCode: res[index][countryCode],
        appleCountryCode: res[index][appleCountryCode],
        defalutMarketCode: res[index][defalutMarketCode],
      );
    });
  }

  Future<List<MARKET>> getMarketDetails() async {
    final database = await db;
    final List<Map<String, dynamic>> res = await database!.rawQuery(
      "SELECT * FROM $marketTable order by PREFERENCE ",
    );

    return List.generate(res.length, (index) {
      return MARKET(
        marketId: int.tryParse(res[index][marketId].toString()) ?? -1,
        marketCode: res[index][marketCode],
        marketName: res[index][marketName],
        countryId: int.tryParse(res[index][countryId].toString()) ?? -1,
        externalCode: res[index][externalCode],
        currencyCode: res[index][currencyCode],
        prefernce: res[index][prefernce],
      );
    });
  }
}
