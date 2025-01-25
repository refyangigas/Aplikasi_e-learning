import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final String baseUrl = 'http://localhost:8000/api/v1';
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw 'Token not found';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      }
      throw jsonDecode(response.body)['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}