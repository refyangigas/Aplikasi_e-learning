import 'package:aplikasi_elearning/material_list_screen.dart';
import 'package:aplikasi_elearning/services/material_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MaterialDetailScreen extends StatefulWidget {
  final int materialId;
  
  const MaterialDetailScreen({
    Key? key, 
    required this.materialId,
  }) : super(key: key);

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  final MaterialService _materialService = MaterialService();
  bool isLoading = true;
  String? error;
  MaterialModel? material;

  @override
  void initState() {
    super.initState();
    fetchMaterialDetail();
  }

  Future<void> fetchMaterialDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final materialDetail = await _materialService.getMaterialDetail(widget.materialId);
      
      setState(() {
        material = materialDetail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material?.title ?? 'Detail Materi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: isLoading 
          ? Center(child: CircularProgressIndicator())
          : error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchMaterialDetail,
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : material != null
              ? Markdown(
                  data: material!.content,
                  padding: EdgeInsets.all(16),
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    h2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    h3: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    p: TextStyle(fontSize: 16, height: 1.5),
                    listBullet: TextStyle(fontSize: 16),
                  ),
                )
              : Center(child: Text('Data tidak ditemukan')),
      ),
    );
  }
}