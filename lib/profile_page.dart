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
  bool _isEditing = false;
  Map<String, dynamic>? _profileData;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _fullNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _isLoading = true);
      final data = await _profileService.getProfile();
      setState(() {
        _profileData = data;
        _isLoading = false;
        // Initialize controllers with current data
        _fullNameController.text = data['user']['full_name'] ?? '';
        if (data['profile'] != null) {
          _birthPlaceController.text = data['profile']['birth_place'] ?? '';
          _birthDateController.text = data['profile']['birth_date'] ?? '';
          _selectedGender = data['profile']['gender'];
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);
      await _profileService.updateProfile(
        fullName: _fullNameController.text,
        birthPlace: _birthPlaceController.text,
        birthDate: _birthDateController.text,
        gender: _selectedGender,
      );
      await _loadProfile(); // Reload profile after update
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLatestScores(),
                  const SizedBox(height: 24),
                  _buildProfileInformation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            _profileData?['user']['full_name'] ?? 'User',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _profileData?['user']['email'] ?? '',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestScores() {
    final scores = _profileData?['last_three_scores'] as List? ?? [];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Scores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...scores.map((score) {
              DateTime dateTime;
              try {
                // Parse ISO 8601 string dan konversi ke waktu lokal
                dateTime = DateTime.parse(score['date']);
              } catch (e) {
                // Fallback jika parsing gagal
                dateTime = DateTime.now();
                print('Error parsing date: $e');
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(dateTime),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${score['score']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInformation() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (_isEditing) {
                      _updateProfile();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditing) _buildEditForm() else _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    final profile = _profileData?['profile'];

    // Format tanggal lahir
    String formattedBirthDate = '-';
    if (profile?['birth_date'] != null && profile!['birth_date'].isNotEmpty) {
      try {
        final birthDate = DateTime.parse(profile['birth_date']);
        formattedBirthDate = DateFormat('dd MMMM yyyy').format(birthDate);
      } catch (e) {
        formattedBirthDate = profile['birth_date'];
      }
    }

    return Column(
      children: [
        _buildInfoRow('Full Name', _profileData?['user']['full_name'] ?? '-'),
        _buildInfoRow('Birth Place', profile?['birth_place'] ?? '-'),
        _buildInfoRow('Birth Date', formattedBirthDate),
        _buildInfoRow('Gender', _capitalizeFirst(profile?['gender'] ?? '-')),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Full name is required';
              return null;
            },
          ),
          TextFormField(
            controller: _birthPlaceController,
            decoration: const InputDecoration(labelText: 'Birth Place'),
          ),
          TextFormField(
            controller: _birthDateController,
            decoration: const InputDecoration(
              labelText: 'Birth Date',
              hintText: 'YYYY-MM-DD',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _birthDateController.text =
                    DateFormat('yyyy-MM-dd').format(date);
              }
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: ['male', 'female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(_capitalizeFirst(value)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedGender = value);
            },
          ),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}
