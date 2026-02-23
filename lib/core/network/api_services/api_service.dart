// lib/app/services/api_service.dart

import 'dart:convert';
import 'package:bin_management_system/core/app_constants/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _buildHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse('${APIURLs.baseURL}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())),
      );
    }
    print("UsedAPIURL: ${uri.toString()}");
    return uri;
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }
    throw Exception(
      decoded['message'] ?? decoded['error'] ?? decoded.toString(),
    );
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = true,
  }) async {
    final response = await http.get(
      _buildUri(endpoint, queryParams: queryParams),
      headers: await _buildHeaders(requiresAuth: requiresAuth),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http.post(
      _buildUri(endpoint),
      headers: await _buildHeaders(requiresAuth: requiresAuth),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http.put(
      _buildUri(endpoint),
      headers: await _buildHeaders(requiresAuth: requiresAuth),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http.patch(
      _buildUri(endpoint),
      headers: await _buildHeaders(requiresAuth: requiresAuth),
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http.delete(
      _buildUri(endpoint),
      headers: await _buildHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }
}
