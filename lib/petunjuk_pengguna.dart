import 'package:flutter/material.dart';

class PetunjukPengguna extends StatefulWidget {
  const PetunjukPengguna({super.key});

  @override
  State<PetunjukPengguna> createState() => _PetunjukPenggunaState();
}

class _PetunjukPenggunaState extends State<PetunjukPengguna> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Petunjuk Pengguna page"),
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