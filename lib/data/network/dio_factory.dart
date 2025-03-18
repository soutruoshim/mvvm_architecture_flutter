import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../app/app_prefs.dart';
import '../../app/constant.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  AppPreferences _appPreferences;
  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    int _timeOut = 60 * 1000; // 1 min
    String language = await _appPreferences.getAppLanguage();
    String token = await _appPreferences.getUserToken();
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: token,
      DEFAULT_LANGUAGE: language // todo get lang from app prefs
    };
    dio.options = BaseOptions(
        baseUrl: Constant.baseUrl,
        connectTimeout: Duration(seconds: _timeOut),
        receiveTimeout: Duration(seconds: _timeOut),
        headers: headers);

    if (kReleaseMode) {
      print("release mode no logs");
    } else {
      // dio.interceptors.add(PrettyDioLogger(
      //     requestHeader: true, requestBody: true, responseHeader: true));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print("REQUEST[${options.method}] => PATH: ${options.path}");
            print("Headers: ${options.headers}");
            print("Data: ${options.data}");
            print("Query Parameters: ${options.queryParameters}");
            handler.next(options); // Continue the request
          },
          onResponse: (response, handler) {
            print("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
            handler.next(response); // Continue the response
          },
          onError: (DioError error, handler) {
            print("ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}");
            print("ERROR RESPONSE: ${error.response?.data}");
            handler.next(error); // Continue error handling
          },
        ),
      );
    }

    return dio;
  }
}