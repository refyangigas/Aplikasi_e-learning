import 'package:aplikasi_elearning/services/material_services.dart';
import 'package:flutter/material.dart';

class MaterialListPage extends StatefulWidget {
  @override
  _MaterialListPageState createState() => _MaterialListPageState();
}

class _MaterialListPageState extends State<MaterialListPage> {
  final MaterialService _materialService = MaterialService();
  late Future<List<Material>> _materialsFuture;

  @override
  void initState() {
    super.initState();
    _materialsFuture = _materialService.getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Pembelajaran'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<Material>>(
        future: _materialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _materialsFuture = _materialService.getMaterials();
                      });
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final materials = snapshot.data!;
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(
                    material.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaterialDetailPage(material: material),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}