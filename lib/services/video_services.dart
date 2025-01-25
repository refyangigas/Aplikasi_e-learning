import 'dart:convert';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final String baseUrl = 'http://192.168.1.11:8000/api/v1';
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
    try {
      if (youtubeUrl.contains('youtu.be')) {
        return youtubeUrl.split('/').last.split('?').first;
      } else if (youtubeUrl.contains('youtube.com')) {
        return Uri.parse(youtubeUrl).queryParameters['v'] ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      youtubeUrl: json['youtube_url'],
    );
  }
}
