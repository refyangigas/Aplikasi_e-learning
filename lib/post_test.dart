import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/services/test_services.dart';

class PostTestScreen extends StatefulWidget {
  const PostTestScreen({Key? key}) : super(key: key);

  @override
  _PostTestScreenState createState() => _PostTestScreenState();
}

class _PostTestScreenState extends State<PostTestScreen> {
  final TestService _testService = TestService();
  int currentQuestionIndex = 1;
  int totalQuestions = 0;
  Question? currentQuestion;
  String? selectedAnswer;
  int correctAnswers = 0;
  bool isLoading = true;
  Map<int, String> userAnswers = {};

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  Future<void> loadQuestion() async {
    setState(() => isLoading = true);
    try {
      final response =
          await _testService.getPostTestQuestion(currentQuestionIndex);
      if (response['success']) {
        setState(() {
          currentQuestion = Question.fromJson(response['data']);
          totalQuestions = response['total'] ?? 0;
          isLoading = false;
          selectedAnswer = userAnswers[currentQuestionIndex];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> submitScore() async {
    try {
      final score = (correctAnswers / totalQuestions) * 100;
      await _testService.submitPostTestResult(
        score: score,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Post-Test Selesai'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.purple, size: 64),
                const SizedBox(height: 16),
                Text('Skor Anda: ${score.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Jawaban Benar: $correctAnswers dari $totalQuestions',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Selesai'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting score: $e')),
        );
      }
    }
  }

  void nextQuestion() {
    if (selectedAnswer == null) return;

    userAnswers[currentQuestionIndex] = selectedAnswer!;
    if (selectedAnswer == currentQuestion?.correctAnswer) {
      correctAnswers++;
    }

    if (currentQuestionIndex < totalQuestions) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
      loadQuestion();
    } else {
      submitScore();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 1) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = userAnswers[currentQuestionIndex];
      });
      loadQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Test'),
        backgroundColor: Colors.purple,
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
                        colors: [Colors.purple.shade100, Colors.purple.shade50],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: currentQuestionIndex / totalQuestions,
                            backgroundColor: Colors.purple.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.purple),
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Soal $currentQuestionIndex dari $totalQuestions',
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              '${(currentQuestionIndex / totalQuestions * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                      case 'B':
                        optionText = currentQuestion?.optionB ?? '';
                      case 'C':
                        optionText = currentQuestion?.optionC ?? '';
                      case 'D':
                        optionText = currentQuestion?.optionD ?? '';
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selectedAnswer == option.toLowerCase()
                              ? Colors.purple
                              : Colors.grey.shade300,
                          width: selectedAnswer == option.toLowerCase() ? 2 : 1,
                        ),
                      ),
                      child: RadioListTile<String>(
                        title: Text(optionText),
                        value: option.toLowerCase(),
                        groupValue: selectedAnswer,
                        activeColor: Colors.purple,
                        onChanged: (value) =>
                            setState(() => selectedAnswer = value),
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
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: selectedAnswer != null ? nextQuestion : null,
                        icon: Icon(currentQuestionIndex < totalQuestions
                            ? Icons.arrow_forward
                            : Icons.check_circle),
                        label: Text(currentQuestionIndex < totalQuestions
                            ? 'Selanjutnya'
                            : 'Selesai'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
