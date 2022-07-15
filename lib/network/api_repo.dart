import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepo {
  static final homeRepo = ApiRepo._();
  String? marketName;
  String? marketCode;
  String? marketId;
  String? countryId;
  String? reorderString;
  List? companyIds;
  String? lang;
  String? theme;
  bool top20 = false;

  Map<String, String>? languageCodeMap = {
    'en': '000',
    'no': 'NOR',
    'sv': 'SWE',
    'da': 'DAN',
    'de': 'GER'
  };

  http.Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  ApiRepo._();

  factory ApiRepo() {
    return homeRepo;
  }

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reorderString = prefs.getString('items') ?? '';
    marketName = prefs.getString(PrefKeys.SELECTED_MARKET) ?? 'National S.E';
    marketCode = prefs.getString(PrefKeys.SELECTED_MARKET_CODE) ?? 'in_nse';
    marketId = prefs.getString(PrefKeys.SELECTED_MARKET_ID) ?? '911';
    countryId = prefs.getString(PrefKeys.SELECTED_COUNTRY_ID) ?? '91';
    lang = prefs.getString(PrefKeys.selectedLang) ?? 'en';
    theme = prefs.getString(PrefKeys.SELECTED_THEME) ?? 'Light';
    top20 = prefs.getBool(PrefKeys.TOP_20) ?? true;
  }

  Future<bool> hasNetwork() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final result = await InternetAddress.lookup("www.google.com");
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Response> getCountryDetails() async {
    // Options cacheOptions =
    //     buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();
    dio.options.connectTimeout = 5000;
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'http://ip-api.com/json',
        //body: json.encode(body.toJson()),
        // options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  getDio() {
    DioCacheManager dioCacheManager = DioCacheManager(CacheConfig());

    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json; charset=UTF-8';
    // dio.options.connectTimeout = 2000;
    dio.interceptors.add(dioCacheManager.interceptor);
    dio.interceptors.add(CustomInterceptors());

    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        logPrint: (object) {
          LoggingInterceptor.longLogPrint(object);
        }));

    return dio;
  }

  Future<Response> getHomePgae(market) async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    companyIds = await DatabaseHelper().getNoteAndFavoriteCompanyIds();
    var top20Flag = '0';
    var favFlag = '0';

    if (top20) top20Flag = '1';
    if (reorderString.toString().contains('7')) favFlag = '1';

    var activeFlag = '$favFlag,$top20Flag,1,1';

    String CompanyIDs = companyIds!.join(",");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return dio.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),

      'https://www.investtech.com/mobile/api.php?page=home&active=$activeFlag&${reorderString == "" ? '' : 'prefs=$reorderString'}&market=$marketCode&countryID=$countryId&lang=${languageCodeMap![lang]}${CompanyIDs.isEmpty ? '' : '&CompanyIDs=$CompanyIDs'}',
      //body: json.encode(body.toJson()),

      options: cacheOptions,
    );
  }

  Future<Response> login(uid, pwd) async {
    Dio dio = getDio();
    try {
      return dio.get(
        'https://www.investtech.com/mobile/api.php?page=checkLoginAndPassword&uid=$uid&pwd=$pwd',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> newsLetterSubscription(uid, mode, marketCode) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=emailNewsletter&prefs=$mode&uid=$uid&market=$marketCode'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  getChartUrl(
      [chartType = CHART_TYPE_FREE,
      chartTerm = CHART_TERM_MEDIUM,
      style = CHART_STYLE_NORMAL,
      companyId]) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "https://www.investtech.com/mobile/img.php?";
    if (chartType == CHART_TYPE_ADVANCED) {
      var type = "top20,$chartTerm";
      url += "type=$type&CompanyID=$companyId";
    } else {
      var type = "free,$companyId";
      url += "type=$type";
    }
    return '$url&size=1080,648&style=$style&variant=mobile&density=2.75';
  }

  Future<Response> getTop20DetailPage() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=top20&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getWebTVList() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=webTV&market=$marketCode&lang=${languageCodeMap![lang]}&countryID=91',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getMCDetailPage() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=marketCommentary&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getIndicesEvalDetailPage() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=indicesEvaluations&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getIndicesAnalysesDetailPage() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    //dio.interceptors.add(CustomInterceptors());
    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=indicesAnalyses&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTodaysSignalDetailPage() async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    await getListValuesSF();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=todaysSignals&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',
        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      //print(e);
      rethrow;
    }
  }

  Future<http.Response> getSearchTerm(term, marketId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/main/autoCompleteSearch.php?output=json&q=${term}&MarketID=${marketId}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<Response> getCompanyData(chartId, companyId) async {
    Options cacheOptions =
        buildCacheOptions(const Duration(hours: 1), forceRefresh: true);
    Dio dio = getDio();

    chartId = chartId.toString();
    try {
      return dio.get(
        //Uri.parse(AppStrings.apiUrl() + "user/login/"),

        'https://www.investtech.com/mobile/api.php?page=advancedChartData&CompanyID=$companyId&chartId=$chartId&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}',

        //body: json.encode(body.toJson()),
        options: cacheOptions,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class LoggingInterceptor implements InterceptorContract {
  static int lastApiCallStatusCode = 0;
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print("${data.method} ${data.url}");
    data.headers.forEach((key, value) {
      print("$key: $value");
    });
    longLogPrint(data.body);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print("${data.statusCode} ${data.url}");
    if (data.statusCode == 401) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // print("Setting statusCode: ${data.statusCode}");
      // prefs.setInt(PrefKeys.LAST_API_STATUS_CODE, data.statusCode);
    }
    data.headers?.forEach((key, value) {
      print("$key: $value");
    });
    longLogPrint(data.body);
    return data;
  }

  static void longLogPrint(Object? object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object.toString());
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    final errorMessage = DioExceptions.fromDioError(err).toString();
    // //print(errorMessage);
    throw errorMessage;
    //return super.onError(err, handler);
  }
}

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioErrorType.other:
        if (dioError.message.contains("SocketException") ||
            dioError.message.contains("No Internet")) {
          message = 'No Internet';
          break;
        }
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
