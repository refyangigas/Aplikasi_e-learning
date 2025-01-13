import 'package:aplikasi_elearning/home_screen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';  // Import splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Set SplashScreen sebagai halaman pertama
    );
  }
}