import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;

class ApiRepo {
  static final homeRepo = ApiRepo._();

  http.Client client = InterceptedClient.build(interceptors: [
    LoggingInterceptor(),
  ]);
  ApiRepo._();

  factory ApiRepo() {
    return homeRepo;
  }

  Future<http.Response> getHomePgae(market) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=home&market=$market&countryID=91&lang=000'),
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

  Future<http.Response> getTop20DetailPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=top20&market=in_nse&countryID=91&lang=000'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getMCDetailPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=marketCommentary&CompanyID=91100930&market=in_nse&countryID=91&lang=000'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getIndicesEvalDetailPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=indicesEvaluations&CompanyID=91100930&market=in_nse&countryID=91&lang=000'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getIndicesAnalysesDetailPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=indicesAnalyses&market=in_nse&countryID=91&lang=000'),
      //body: json.encode(body.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> getTodaysSignalDetailPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=todaysSignals&market=in_nse&countryID=91&lang=000'),
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
    print(chartId);
    return client.get(
      //Uri.parse(AppStrings.apiUrl() + "user/login/"),
      Uri.parse(
          'https://www.investtech.com/mobile/api.php?page=advancedChartData&CompanyID=$companyId&chartId=$chartId&market=in_nse&countryID=91&lang=000'),

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
