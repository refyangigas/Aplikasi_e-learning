import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/services/UserGuide_services.dart';

class PetunjukPengguna extends StatefulWidget {
  const PetunjukPengguna({Key? key}) : super(key: key);

  @override
  _PetunjukPenggunaState createState() => _PetunjukPenggunaState();
}

class _PetunjukPenggunaState extends State<PetunjukPengguna> {
  final UserGuideService _service = UserGuideService();
  List<UserGuideModel> _guides = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    try {
      final guides = await _service.getUserGuides();
      setState(() {
        _guides = guides;
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
        title: const Text('Petunjuk Pengguna'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _loadGuides,
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
                onPressed: _loadGuides,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_guides.isEmpty) {
      return const Center(
        child: Text('Tidak ada petunjuk pengguna'),
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
        itemCount: _guides.length,
        itemBuilder: (context, index) {
          final guide = _guides[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.all(16),
              title: Text(
                'Petunjuk ${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Text(
                  guide.content,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
