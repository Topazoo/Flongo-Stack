import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class HTTPClient {
  static final env = dotenv.env;
  final String baseUrl;
  final Duration timeoutDuration;
  Map<String, String> headers = {
    'accept': 'application/json',
  };

  HTTPClient(String url, {String? csrfToken})
      : baseUrl = '${env['APP_API_URL']}/$url',
        timeoutDuration = Duration(milliseconds: int.parse(env['APP_API_TIMEOUT_MS'] ?? '3000')) {
    if (csrfToken != null) {
      headers['X-CSRF-TOKEN'] = csrfToken;
    }
  }

  Future<void> _requestWrapper(Function requestFunc, {Function? onSuccess, Function? onError}) async {
    try {
      var response = await requestFunc().timeout(timeoutDuration);
      _handleResponse(response, onSuccess, onError);
    } catch (e) {
      if (e is http.ClientException) {
        onError?.call(http.Response('${e.message} Please ensure the server is running: [$baseUrl]', 400));
      } else if (e is TimeoutException) {
        onError?.call(http.Response('Request timed out', 408));
      } else {
        onError?.call(http.Response('An unexpected error occurred: $e', 500));
      }
    }
  }

  void _handleResponse(http.Response response, Function? onSuccess, Function? onError) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (onSuccess != null) onSuccess(response);
    } else {
      if (onError != null) onError(response);
    }
  }

  Future<void> get({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      return http.get(uri, headers: headers);
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> post({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> put({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return http.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> patch({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return http.patch(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> delete({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      return http.delete(uri, headers: headers);
    }, onSuccess: onSuccess, onError: onError);
  }
}
