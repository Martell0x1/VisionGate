import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vision_gate/models/login.dart';
import '../models/user.dart';
import './token_manager.dart';

/// كلاس موحد للنتايج
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});
}

class ApiService {
  final String baseUrl = "http://localhost:3000";

  /// اختبار الاتصال بالـ API
  Future<ApiResponse<Map<String, dynamic>>> testApi() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/databaseConfig/health"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: "خطأ في السيرفر: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  /// تسجيل مستخدم جديد
  Future<ApiResponse<Map<String, dynamic>>> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(user.toJson()),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: "فشل التسجيل: ${data['message']}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  /// Login for registered user
  Future<ApiResponse<Map<String, dynamic>>> userlogin(Login user) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(user.toJson()),
    );

    final data = json.decode(response.body) as Map<String, dynamic>;
    
    if (response.statusCode == 201) {
      // Extract and store tokens
      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      
      if (accessToken != null) {
        await TokenManager.saveTokens(accessToken, refreshToken ?? '');
      }
      
      return ApiResponse(success: true, data: data);
    } else {
      return ApiResponse(
        success: false,
        message: "فشل التسجيل: ${data['message']}",
      );
    }
  } catch (e) {
    return ApiResponse(success: false, message: "Exception: $e");
  }
}
}
