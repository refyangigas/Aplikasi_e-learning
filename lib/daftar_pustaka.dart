import 'package:flutter/material.dart';

class DaftarPustaka extends StatefulWidget {
  const DaftarPustaka({super.key});

  @override
  State<DaftarPustaka> createState() => _DaftarPustakaState();
}

class _DaftarPustakaState extends State<DaftarPustaka> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pustaka Page"),
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