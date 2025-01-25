import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ReferenceService {
  final String baseUrl = 'http://localhost:8000/api/v1';
  final AuthService _authService = AuthService();

  Future<List<ReferenceModel>> getReferences() async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        throw 'Token not found. Please login first.';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/references'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<ReferenceModel> references = (responseData['data'] as List)
            .map((item) => ReferenceModel.fromJson(item))
            .toList();
        return references;
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load references';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

class ReferenceModel {
  final int id;
  final String content;
  final String? createdAt;
  final String? updatedAt;

  ReferenceModel({
    required this.id,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}