import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class UserGuideService {
  final String baseUrl = 'http://192.168.1.13:8000/api/v1';
  final AuthService _authService = AuthService();

  Future<List<UserGuideModel>> getUserGuides() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw 'Token not found. Please login first.';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user-guides'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<UserGuideModel> guides = (responseData['data'] as List)
            .map((item) => UserGuideModel.fromJson(item))
            .toList();
        return guides;
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load user guides';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

class UserGuideModel {
  final int id;
  final String content;
  final String? createdAt;
  final String? updatedAt;

  UserGuideModel({
    required this.id,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory UserGuideModel.fromJson(Map<String, dynamic> json) {
    return UserGuideModel(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
