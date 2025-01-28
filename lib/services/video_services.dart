import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VideoService {
  final String baseUrl = 'http://192.168.1.13:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> getVideos({int page = 1}) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/videos?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load videos';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> getVideo(int id) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/videos/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw errorResponse['message'] ?? 'Failed to load video';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}