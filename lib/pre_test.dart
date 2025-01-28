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
  bool isLoading = true;

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
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < totalQuestions) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      loadQuestion();
    } else {
      // Selesai Pre-Test
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pre-Test Selesai'),
          content: const Text('Anda telah menyelesaikan Pre-Test'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke home
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 1) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = null;
      });
      loadQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre Test'),
        backgroundColor: Colors.orange, // Sesuai dengan ikon di home
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
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: currentQuestionIndex / totalQuestions,
                          backgroundColor: Colors.orange.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.orange),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Soal $currentQuestionIndex dari $totalQuestions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        currentQuestion?.question ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...['A', 'B', 'C', 'D'].map((option) {
                    String optionText = '';
                    switch (option) {
                      case 'A':
                        optionText = currentQuestion?.optionA ?? '';
                        break;
                      case 'B':
                        optionText = currentQuestion?.optionB ?? '';
                        break;
                      case 'C':
                        optionText = currentQuestion?.optionC ?? '';
                        break;
                      case 'D':
                        optionText = currentQuestion?.optionD ?? '';
                        break;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: RadioListTile<String>(
                        title: Text(optionText),
                        value: option,
                        groupValue: selectedAnswer,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() => selectedAnswer = value);
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            currentQuestionIndex > 1 ? previousQuestion : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Sebelumnya'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: selectedAnswer != null ? nextQuestion : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          currentQuestionIndex < totalQuestions
                              ? 'Selanjutnya'
                              : 'Selesai',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
