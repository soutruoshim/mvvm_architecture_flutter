// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AppServiceClient implements AppServiceClient {
  _AppServiceClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://srhdp.wiremockapi.cloud';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AuthenticationResponse> login(
    String email,
    String password,
    String imei,
    String deviceType,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'password': password,
      'imei': imei,
      'deviceType': deviceType,
    };
    Logger().d("before request");
    try {
      final response = await _dio.fetch(
        Options(
          method: 'POST',
          headers: _headers,
          extra: _extra,
          responseType: ResponseType.json, // Expect JSON
        ).compose(
          _dio.options,
          '/customers/login',
          queryParameters: queryParameters,
          data: _data,
        ).copyWith(
          baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
        ),
      );
      if (response.data is String) {
        print("Plain text response: ${response.data}");
      } else if (response.data is Map<String, dynamic>) {
        print("JSON response: ${response.data}");
      }

    } catch (e) {
      print("Error: $e");
    }
    try{
      final _result = await _dio.fetch<Map<String, dynamic>>(
          _setStreamType<AuthenticationResponse>(Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            responseType: ResponseType.json
          )
              .compose(
            _dio.options,
            '/customers/login',
            queryParameters: queryParameters,
            data: _data,
          )
              .copyWith(
              baseUrl: _combineBaseUrls(
                _dio.options.baseUrl,
                baseUrl,
              ))));
      Logger().d("end request");
      Logger().d(_result.data!);
    }catch(e){
      Logger().d(e);
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthenticationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customers/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    Logger().d("end request");
    Logger().d(_result.data!);
    final value = AuthenticationResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
