import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class HTTPClient {
  static final env = dotenv.env;
  final String baseUrl;
  Map<String, String> headers = {
    'accept': 'application/json',
  };

  HTTPClient(String url, {String? csrfToken}) : baseUrl = '${env['APP_API_URL']}/$url' {
    if (csrfToken != null) {
      headers['X-CSRF-TOKEN'] = csrfToken;
    }
  }

  void _handleResponse(http.Response response, Function? onSuccess, Function? onError) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (onSuccess != null) onSuccess(response);
    } else {
      if (onError != null) onError(response);
    }
  }

  Future<void> get({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) async {
    var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    var response = await http.get(uri, headers: headers);
    _handleResponse(response, onSuccess, onError);
  }

  Future<void> post({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) async {
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(body),
    );
    _handleResponse(response, onSuccess, onError);
  }

  Future<void> put({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) async {
    var response = await http.put(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(body),
    );
    _handleResponse(response, onSuccess, onError);
  }

  Future<void> patch({Map<String, dynamic>? body, Function? onSuccess, Function? onError}) async {
    var response = await http.patch(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(body),
    );
    _handleResponse(response, onSuccess, onError);
  }

  Future<void> delete({Map<String, String>? queryParams, Function? onSuccess, Function? onError}) async {
    var uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    var response = await http.delete(uri, headers: headers);
    _handleResponse(response, onSuccess, onError);
  }
}
