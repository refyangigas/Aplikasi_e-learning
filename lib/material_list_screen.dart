import 'package:aplikasi_elearning/material_detail_screen.dart';
import 'package:aplikasi_elearning/services/material_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MaterialListScreen extends StatefulWidget {
  @override
  _MaterialListScreenState createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  final MaterialService _materialService = MaterialService();
  List<MaterialModel> materialList = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final materials = await _materialService.getMaterials();

      setState(() {
        materialList = materials;
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
        title: const Text('Daftar Materi'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (error != null) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error!),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: fetchMaterials,
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (materialList.isEmpty) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Text('Belum ada materi tersedia'),
              ),
            );
          }

          return Container(
            color: Colors.white,
            child: RefreshIndicator(
              onRefresh: fetchMaterials,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: materialList.length,
                itemBuilder: (context, index) {
                  final material = materialList[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MaterialDetailScreen(materialId: material.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.book,
                                size: 32,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tap untuk membaca',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
