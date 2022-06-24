import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investtech_app/network/models/country.dart';
import 'package:investtech_app/network/models/favorites.dart';
import 'package:investtech_app/network/models/market.dart';
import 'package:investtech_app/network/models/recent_search.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int version = 1;
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

  static const String favoriteTable = "FAVORITE";
  static const String companyName = "COMPANY_NAME";
  static const String companyId = "COMPANY_ID";
  static const String ticker = "TICKER";
  static const String note = "NOTE";
  static const String noteTimestamp = "NOTE_TIMESTAMP";
  static const String timestamp = "TIMESTAMP";

  static const String searchTable = "RECENT_SEARCH";

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
    return await openDatabase(
      path,
      version: version,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
    List tableList = tables.map((e) => e["name"]).toList();
    print("tables = ${tables.map((e) => e["name"]).toList()}");
    print("contains favorite table = ${tableList.contains(favoriteTable)}");
    if (tableList.contains(favoriteTable) == false) {
      await db.execute('''
           CREATE TABLE $favoriteTable(
             $companyName TEXT,
             $companyId TEXT PRIMARY KEY,
             $ticker TEXT,
             $note TEXT,
             $noteTimestamp TEXT
           )
           ''');
    }

    if (tableList.contains(searchTable) == false) {
      await db.execute('''
           CREATE TABLE $searchTable(
             $ticker TEXT PRIMARY KEY,
             $companyId TEXT,
             $countryCode TEXT,
             $companyName TEXT,
             $timestamp TEXT
           )
           ''');
    }
  }

  Future<void> addRecentSearch(RecentSearch recentSearch) async {
    final database = await db;
    await database?.rawQuery(
        "INSERT OR REPLACE INTO $searchTable($ticker,$companyId,$countryCode,$companyName,$timestamp) values (?,?,?,?,?)",
        [
          recentSearch.ticker,
          recentSearch.companyId,
          recentSearch.countryCode,
          recentSearch.companyName,
          recentSearch.timestamp
        ]);
  }

  Future<void> addNoteAndFavorite(Favorites favorite) async {
    final database = await db;
    await database?.rawQuery(
        "INSERT OR REPLACE INTO $favoriteTable($companyName,$companyId,$ticker,$note,$noteTimestamp) values (?,?,?,?,?)",
        [
          favorite.companyName,
          favorite.companyId,
          favorite.ticker,
          favorite.note,
          favorite.noteTimestamp
        ]);
  }

  Future<List<Favorites>> getNoteAndFavorite() async {
    final database = await db;

    final List<Map<String, dynamic>> res = await database!.rawQuery(
      "SELECT * FROM $favoriteTable ",
    );

    return List.generate(res.length, (index) {
      return Favorites(
        companyName: res[index][companyName],
        companyId: res[index][companyId],
        ticker: res[index][ticker],
        note: res[index][note],
        noteTimestamp: res[index][noteTimestamp],
      );
    });
  }

  Future<List<RecentSearch>> getRecentSearches() async {
    final database = await db;

    final List<Map<String, dynamic>> res = await database!.rawQuery(
      "SELECT * FROM $searchTable ",
    );
    print(res);

    return List.generate(res.length, (index) {
      return RecentSearch(
        ticker: res[index][ticker],
        companyId: res[index][companyId],
        countryCode: res[index][countryCode],
        companyName: res[index][companyName],
        timestamp: res[index][timestamp],
      );
    });
  }

  getNoteAndFavoriteCompanyIds() async {
    final database = await db;

    final List<Map<String, dynamic>> res = await database!.rawQuery(
      "SELECT $companyId FROM $favoriteTable ",
    );
    // print(res);
    //print(res[0]['COMPANY_ID']);
    return List.generate(res.length, (index) {
      return res[index]['COMPANY_ID'];
    });
  }

  checkNoteAndFavorite(cmpId) async {
    final database = await db;

    final List<Map<String, dynamic>> res = await database!.rawQuery(
        "SELECT  COUNT(*), $note, $noteTimestamp FROM $favoriteTable  where $companyId=?",
        [cmpId]);

    print(res);
    if (Sqflite.firstIntValue(res) == 1) {
      return jsonEncode({
        'isFavourite': true,
        'note': res[0][note],
        'timeStamp': res[0][noteTimestamp]
      });
    } else {
      return jsonEncode(
          {'isFavourite': false, 'note': false, 'timeStamp': false});
    }
  }

  Future<int> deleteNoteAndFavourite(cmpId) async {
    final database = await db;

    return await database!
        .rawDelete("DELETE FROM $favoriteTable WHERE $companyId=?", [cmpId]);
  }

  Future<int> deleteAllNotesAndFavourites() async {
    final database = await db;

    return await database!.rawDelete("DELETE  FROM $favoriteTable");
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
