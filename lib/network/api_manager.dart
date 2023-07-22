import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

class ApiManager {
  final String _baseUrl = "jsonplaceholder.typicode.com";

  Future<http.Response?> get(String url) async {
    Uri uri = Uri.https(_baseUrl, url);
    return await http.get(uri);
  }

  Future<http.Response?> post(String url, Map<String, dynamic> parameters) async {
    Uri uri = Uri.https(_baseUrl, url);
    return await http.post(uri, body: jsonEncode(parameters));
  }
}