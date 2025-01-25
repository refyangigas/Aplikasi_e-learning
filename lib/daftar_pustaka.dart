import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/services/Reference_services.dart';

class DaftarPustaka extends StatefulWidget {
  const DaftarPustaka({Key? key}) : super(key: key);

  @override
  _DaftarPustakaState createState() => _DaftarPustakaState();
}

class _DaftarPustakaState extends State<DaftarPustaka> {
  final ReferenceService _service = ReferenceService();
  List<ReferenceModel> _references = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    try {
      final references = await _service.getReferences();
      setState(() {
        _references = references;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pustaka'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadReferences,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReferences,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_references.isEmpty) {
      return const Center(
        child: Text('Tidak ada daftar pustaka'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        itemCount: _references.length,
        itemBuilder: (context, index) {
          final reference = _references[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                reference.content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}