import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vision_gate/models/login.dart';
import '../models/user.dart';
import '../models/vehicle.dart';
import './token_manager.dart';
import './server_config.dart';

/// كلاس موحد للنتايج
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});
}

class ApiService {
  /// Always resolve baseUrl dynamically
  Future<String> _getBaseUrl() async {
    final stored = await ServerConfig.getBaseUrl();
    return stored ?? "http://localhost:3000"; // fallback default
  }

  /// اختبار الاتصال بالـ API
  Future<ApiResponse<Map<String, dynamic>>> testApi() async {
    try {
      final baseUrl = await _getBaseUrl(); // ✅ use dynamic baseUrl
      final response = await http.get(
        Uri.parse("$baseUrl/databaseConfig/health"),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      final baseUrl = await _getBaseUrl(); // ✅ use dynamic baseUrl
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
          message: "فشل التسجيل: ${data['message'] ?? 'خطأ غير معروف'}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  /// Login for registered user
  Future<ApiResponse<Map<String, dynamic>>> userlogin(Login user) async {
    try {
      final baseUrl = await _getBaseUrl(); // ✅ use dynamic baseUrl
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(user.toJson()),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
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
          message: "فشل تسجيل الدخول: ${data['message'] ?? 'خطأ غير معروف'}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserByEmail(String email) async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.post(
        Uri.parse("$baseUrl/user/findByEmail"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message:
              "فشل جلب بيانات المستخدم: ${data['message'] ?? 'خطأ غير معروف'}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> addCar(Vehicle car) async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.post(
        Uri.parse("$baseUrl/cars"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(car.toJson()),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(success: true, data: data);
      } else {
        return ApiResponse(
          success: false,
          message: "${data['message'] ?? 'خطأ غير معروف'}",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getUserCars(int userId) async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(
        Uri.parse("$baseUrl/cars/usercars/$userId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawList = json.decode(response.body);

        // ✅ Safely cast to List<Map<String, dynamic>>
        final List<Map<String, dynamic>> jsonList =
            List<Map<String, dynamic>>.from(rawList);

        return ApiResponse(success: true, data: jsonList);
      } else {
        return ApiResponse(
          success: false,
          message: "خطأ غير معروف",
        );
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Exception: $e");
    }
  }
}
