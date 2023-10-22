import 'dart:async';

import 'mutliplatform/base_http_client_factory.dart';
import 'mutliplatform/cookie_service_factory.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';


class HTTPClient {
  static final env = dotenv.env;
  final String baseUrl;
  final http.Client _client = getCustomClient();
  final Duration timeoutDuration;
  static Map<String, String> headers = {
    'accept': 'application/json',
  };

  static String? _cookie;

  HTTPClient(String url, {String? csrfToken})
        : baseUrl = '${env['APP_API_URL']}/${url.startsWith("/") ? url.substring(1) : url}',
        timeoutDuration = Duration(milliseconds: int.parse(env['APP_API_TIMEOUT_MS'] ?? '3000')) {

    if (csrfToken != null) {
      headers['X-CSRF-TOKEN'] = csrfToken;
    }

    if (_cookie != null) {
      setCookie(_cookie!);
    }
  }

  static void deAuthenticate() {
    // TODO - Clear from browser?
    _cookie = null;
    headers.remove('cookie');
  }

  void setCookie(String cookie) {
    _cookie = cookie;
    headers['cookie'] = cookie;
  }

  static bool isAuthenticated() {
    // If there is a cookie set for the application or an identity cookie present in
    // the browser cookies
    return _cookie != null || getIdentityCookie() != null;
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
    if (response.statusCode == 401) {
      // Invalidate the cookie and set authenticated to false for 401 Unauthorized response
      deAuthenticate();
    } else {
      _updateCookie(response);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (onSuccess != null) onSuccess(response);
    } else {
      if (onError != null) onError(response);
    }
  }

  void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      setCookie(cookie);
    }
  }

  Future<void> get({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      return _client.get(uri, headers: headers);
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> post({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return _client.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> put({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return _client.put(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> patch({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      return _client.patch(
        Uri.parse(baseUrl),
        headers: headers,
        body: json.encode(body),
      );
    }, onSuccess: onSuccess, onError: onError);
  }

  Future<void> delete({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) {
    return _requestWrapper(() {
      var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      return _client.delete(uri, headers: headers);
    }, onSuccess: onSuccess, onError: onError);
  }
}
