import 'package:get/get.dart';
import 'package:aplikasi_elearning/services/test_service.dart';

class TestController extends GetxController {
  final _testService = TestService();
  final tests = <Test>[].obs;
  final currentIndex = 0.obs;
  final isLoading = false.obs;

  Future<void> loadPreTests() async {
    try {
      isLoading.value = true;
      tests.value = await _testService.getPreTests();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPostTests() async {
    try {
      isLoading.value = true;
      tests.value = await _testService.getPostTests();
    } finally {
      isLoading.value = false;
    }
  }

  void nextQuestion() {
    if (currentIndex.value < tests.length - 1) {
      currentIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  Test? get currentQuestion => tests.isEmpty ? null : tests[currentIndex.value];
}
