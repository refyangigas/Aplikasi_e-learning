import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/home_screen.dart';
import 'package:aplikasi_elearning/auth/login_screen.dart';

class PostTest extends StatefulWidget {
  const PostTest({super.key});

  @override
  State<PostTest> createState() => _PostTestState();
}

class _PostTestState extends State<PostTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Test Page"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text("1. What is the largest planet in our solar system?"),
            Row(
              children: [
                const Text("a) Earth"),
                const SizedBox(width: 10),
                const Text("b) Mars"),
                const SizedBox(width: 10),
                const Text("c) Jupiter"),
                const SizedBox(width: 10),
                const Text("d) Saturn"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("2. Who wrote 'Romeo and Juliet'?"),
            Row(
              children: [
                const Text("a) Charles Dickens"),
                const SizedBox(width: 10),
                const Text("b) Mark Twain"),
                const SizedBox(width: 10),
                const Text("c) William Shakespeare"),
                const SizedBox(width: 10),
                const Text("d) Jane Austen"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
