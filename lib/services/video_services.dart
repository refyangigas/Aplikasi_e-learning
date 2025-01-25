import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final String baseUrl = 'http://localhost:8000/api/v1';
  final AuthService _authService = AuthService();

  Future<List<VideoModel>> getVideos() async {
    try {
      final token = await _authService.getToken();
      if (token == null) throw 'Token not found';

      final response = await http.get(
        Uri.parse('$baseUrl/videos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return (responseData['data'] as List)
            .map((item) => VideoModel.fromJson(item))
            .toList();
      } 
      throw jsonDecode(response.body)['message'] ?? 'Failed to load videos';
    } catch (e) {
      throw e.toString();
    }
  }
}

class VideoModel {
  final int id;
  final String title;
  final String youtubeUrl;

  VideoModel({
    required this.id,
    required this.title,
    required this.youtubeUrl,
  });

  String get videoId {
    final uri = Uri.parse(youtubeUrl);
    return uri.pathSegments.last.split('?').first;
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      youtubeUrl: json['youtube_url'],
    );
  }
}