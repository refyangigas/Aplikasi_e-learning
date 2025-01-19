import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MaterialService {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  Future<List<Material>> getMaterials() async {
    // Dapatkan token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Pastikan key 'token' sesuai dengan yang Anda simpan
    
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/materials'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final List<dynamic> materialsJson = data['data'] as List;
        return materialsJson.map((json) => Material.fromJson(json)).toList();
      }
      throw Exception(data['message']);
    }
    throw Exception('Failed to load materials');
  }
}

// Model class
class Material {
  final int id;
  final String title;
  final String content;
  final String updatedAt;

  Material({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      updatedAt: json['updated_at'],
    );
  }
}