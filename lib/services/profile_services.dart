import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  final String baseUrl = 'http://192.168.1.13:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to get profile';
      }
    } catch (e) {
      print('Error in getProfile: $e');
      throw e.toString();
    }
  }

  Future<void> updateProfile({
    required String fullName,
    String? birthPlace,
    String? birthDate,
    String? gender,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName,
          'birth_place': birthPlace,
          'birth_date': birthDate,
          'gender': gender,
        }),
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to update profile';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
