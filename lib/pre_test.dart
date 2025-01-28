import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/services/auth_services.dart';
import 'package:aplikasi_elearning/services/test_services.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({Key? key}) : super(key: key);

  @override
  _PreTestScreenState createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  final TestService _testService = TestService();
  int currentQuestionIndex = 1;
  int totalQuestions = 0;
  Question? currentQuestion;
  String? selectedAnswer;
  int correctAnswers = 0; // Menambahkan penghitung jawaban benar
  bool isLoading = true;
  Map<int, String> userAnswers = {}; // Menambahkan penyimpanan jawaban

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  Future<void> loadQuestion() async {
    setState(() => isLoading = true);
    try {
      final response =
          await _testService.getPreTestQuestion(currentQuestionIndex);

      if (response['success']) {
        setState(() {
          currentQuestion = Question.fromJson(response['data']);
          totalQuestions = response['total'] ?? 0;
          isLoading = false;
          selectedAnswer = userAnswers[
              currentQuestionIndex]; // Memuat jawaban yang tersimpan
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void nextQuestion() {
    if (selectedAnswer == null) return;

    // Simpan jawaban dan cek kebenaran
    userAnswers[currentQuestionIndex] = selectedAnswer!;
    if (selectedAnswer?.toLowerCase() ==
        currentQuestion?.correctAnswer.toLowerCase()) {
      correctAnswers++;
    }

    if (currentQuestionIndex < totalQuestions) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      loadQuestion();
    } else {
      // Tampilkan hasil pre-test
      showResultDialog();
    }
  }

  void showResultDialog() {
    final score = (correctAnswers / totalQuestions) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pre-Test Selesai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.orange, size: 64),
            const SizedBox(height: 16),
            Text(
              'Skor Anda: ${score.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Jawaban Benar: $correctAnswers dari $totalQuestions',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void previousQuestion() {
    if (currentQuestionIndex > 1) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer =
            userAnswers[currentQuestionIndex]; // Memuat jawaban sebelumnya
      });
      loadQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre Test'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade100, Colors.orange.shade50],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: currentQuestionIndex / totalQuestions,
                            backgroundColor: Colors.orange.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Soal $currentQuestionIndex dari $totalQuestions',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${(currentQuestionIndex / totalQuestions * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ... sisa kode build tetap sama ...
                ],
              ),
            ),
    );
  }
}
