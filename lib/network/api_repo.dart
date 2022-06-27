import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/ui/news_letter_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepo {
  static final homeRepo = ApiRepo._();
  String? marketName;
  String? marketCode;
  String? reorderString;
  List? companyIds;
  String? lang;
  String? theme;

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
    lang = prefs.getString(PrefKeys.selectedLang) ?? 'en';
    theme = prefs.getString(PrefKeys.SELECTED_THEME) ?? 'Light';
  }

  Future<http.Response> getHomePgae(market) async {
    await getListValuesSF();
    companyIds = await DatabaseHelper().getNoteAndFavoriteCompanyIds();

    String CompanyIDs = companyIds!.join(",");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=home&active=1,1,1,1&${reorderString == "" ? '' : 'prefs=$reorderString'}&market=$market&countryID=91&lang=${languageCodeMap![lang]}${CompanyIDs.isEmpty ? '' : '&CompanyIDs=$CompanyIDs'}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> login(uid, pwd) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=checkLoginAndPassword&uid=$uid&pwd=$pwd'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
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
    if (theme == 'Dark') {
      style = '1';
    }
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

  Future<http.Response> getTop20DetailPage() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=top20&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getWebTVList() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=webTV&market=$marketCode&lang=${languageCodeMap![lang]}&countryID=91'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getMCDetailPage() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=marketCommentary&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getIndicesEvalDetailPage() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=indicesEvaluations&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getIndicesAnalysesDetailPage() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=indicesAnalyses&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getTodaysSignalDetailPage() async {
    await getListValuesSF();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=todaysSignals&market=$marketCode&countryID=91&lang=${languageCodeMap![lang]}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getSearchTerm(term, marketId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/main/autoCompleteSearch.php?output=json&q=${term}&MarketId=${marketId}'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getCompanyData(chartId, companyId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    chartId = chartId.toString();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=advancedChartData&CompanyID=$companyId&chartId=$chartId&market=in_nse&countryID=91&lang=${languageCodeMap![lang]}'),

      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
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
