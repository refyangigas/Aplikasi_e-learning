import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class MaterialService {
  final String baseUrl = 'http://192.168.1.13:8000/api/v1';
  final AuthService _authService = AuthService();

  Future<List<MaterialModel>> getMaterials() async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        throw 'Token not found. Please login first.';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/materials'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<MaterialModel> materials = (responseData['data'] as List)
            .map((item) => MaterialModel.fromJson(item))
            .toList();
        return materials;
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load materials';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<MaterialModel> getMaterialDetail(int id) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        throw 'Token not found. Please login first.';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/materials/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MaterialModel.fromJson(responseData['data']);
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load material detail';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

class MaterialModel {
  final int id;
  final String title;
  final String content;
  final String? createdAt;
  final String? updatedAt;

  MaterialModel({
    required this.id,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}