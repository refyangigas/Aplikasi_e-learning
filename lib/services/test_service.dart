// lib/services/test_service.dart
import 'package:dio/dio.dart';

class Test {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;

  Test({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      question: json['question'],
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correctAnswer: json['correct_answer'],
    );
  }
}

class TestService {
  final Dio _dio = Dio()
    ..options.baseUrl = 'http://10.0.2.2:8000'  // Sesuaikan dengan URL Anda
    ..options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
    ..options.connectTimeout = const Duration(seconds: 5)
    ..options.receiveTimeout = const Duration(seconds: 3);

  Future<List<Test>> getPreTests() async {
    try {
      final response = await _dio.get('/api/pre-tests');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Test.fromJson(json)).toList();
      }
      throw Exception('Failed to load pre tests');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Test>> getPostTests() async {
    try {
      final response = await _dio.get('/api/post-tests');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Test.fromJson(json)).toList();
      }
      throw Exception('Failed to load post tests');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> submitPostTestScore(double score) async {
    try {
      await _dio.post('/api/post-test/submit', data: {
        'score': score
      });
    } catch (e) {
      throw Exception('Error submitting score: $e');
    }
  }
}