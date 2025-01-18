import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/home_screen.dart';
import 'package:aplikasi_elearning/auth/login_screen.dart';

class PreTest extends StatefulWidget {
  const PreTest({super.key});

  @override
  State<PreTest> createState() => _PreTestState();
}

class _PreTestState extends State<PreTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre Test Page"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text("1. What is the capital of France?"),
            Row(
              children: [
                const Text("a) Berlin"),
                const SizedBox(width: 10),
                const Text("b) Madrid"),
                const SizedBox(width: 10),
                const Text("c) Paris"),
                const SizedBox(width: 10),
                const Text("d) Rome"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("2. Which language is primarily spoken in Brazil?"),
            Row(
              children: [
                const Text("a) Spanish"),
                const SizedBox(width: 10),
                const Text("b) Portuguese"),
                const SizedBox(width: 10),
                const Text("c) French"),
                const SizedBox(width: 10),
                const Text("d) English"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
