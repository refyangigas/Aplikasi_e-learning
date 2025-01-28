import 'package:aplikasi_elearning/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  final _formKey = GlobalKey<FormState>();

  // Controllers for edit form
  final _fullNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await _profileService.getProfile();
      setState(() {
        _profileData = data;
        _isLoading = false;
        // Initialize controllers with existing data
        _fullNameController.text = data['full_name'] ?? '';
        _birthPlaceController.text = data['birth_place'] ?? '';
        _selectedGender = data['gender'];
        _selectedDate = data['birth_date'] != null
            ? DateTime.parse(data['birth_date'])
            : null;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _birthPlaceController,
                    decoration: const InputDecoration(labelText: 'Birth Place'),
                  ),
                  ListTile(
                    title: Text(_selectedDate == null
                        ? 'Select Birth Date'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _profileService.updateProfile(
          fullName: _fullNameController.text,
          birthPlace: _birthPlaceController.text,
          birthDate: _selectedDate?.toIso8601String(),
          gender: _selectedGender,
        );
        if (mounted) {
          Navigator.pop(context);
          _loadProfile();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _profileData?['full_name'] ?? 'Test User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _profileData?['email'] ?? 'test@example.com',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_profileData?['last_three_scores'] != null)
                    ..._buildScoreCards(_profileData!['last_three_scores']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScoreCards(List<dynamic> scores) {
    return scores.map((score) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text(
            '${score['score']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            DateFormat('dd MMM yyyy HH:mm').format(
              DateTime.parse(score['date']),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }
}
