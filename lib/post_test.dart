import 'package:flutter/material.dart';

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
        title: const Text("post-test page"),
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
