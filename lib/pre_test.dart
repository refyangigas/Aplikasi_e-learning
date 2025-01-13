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
        title: const Text("pre test page"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
