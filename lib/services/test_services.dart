import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Question {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
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
  final String baseUrl = 'http://192.168.1.6:8000/api/v1'; // Perbaikan URL
  final storage = const FlutterSecureStorage();
  final http.Client client = http.Client();

  // Get all pre-test questions
  Future<List<Question>> getAllPreTestQuestions() async {
    final response = await client.get(
      Uri.parse('$baseUrl/pre-test/questions'), // Sesuaikan dengan route API
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to load pre-test questions');
  }

  Future<Map<String, dynamic>> getPreTestQuestion(int index) async {
    final response = await client.get(
      Uri.parse(
          '$baseUrl/pre-test/questions/$index'), // Sesuaikan dengan route API
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }

  // Get all post-test questions
  Future<List<Question>> getAllPostTestQuestions() async {
    final response = await client.get(
      Uri.parse('$baseUrl/post-test/questions'), // Sesuaikan dengan route API
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
      }
    }
    throw Exception('Failed to load post-test questions');
  }

  Future<Map<String, dynamic>> getPostTestQuestion(int index) async {
    final response = await client.get(
      Uri.parse(
          '$baseUrl/post-test/questions/$index'), // Sesuaikan dengan route API
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load question');
    }
  }

  // Submit pre-test result
  Future<Map<String, dynamic>> submitPreTestResult({
    required double score,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/pre-test/submit'), // Sesuaikan dengan route API
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'score': score,
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit pre-test result');
    }
  }

  // Submit post-test result
  Future<Map<String, dynamic>> submitPostTestResult({
    required double score,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/post-test/submit'), // Sesuaikan dengan route API
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'score': score,
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit post-test result');
    }
  }

  Future<String> getToken() async {
    // Implementasi pengambilan token dari secure storage
    final token = await storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token not found');
    }
    return token;
  }

  submitPostTestScore(
      {required double score,
      required int totalQuestions,
      required int correctAnswers}) {}
}
