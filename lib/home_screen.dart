import 'package:aplikasi_elearning/daftar_pustaka.dart';
import 'package:aplikasi_elearning/petunjuk_pengguna.dart';
import 'package:aplikasi_elearning/pre_test.dart';
import 'package:aplikasi_elearning/video_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/menu_materi.dart';
import 'package:aplikasi_elearning/auth/login_screen.dart';
import 'package:aplikasi_elearning/post_test.dart'; // Pastikan import ini sesuai

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default ke home (index 1)

  // Halaman untuk Profile
  Widget _buildProfilePage() {
    return const Center(
      child: Text('Profile Page'), // Ganti dengan konten profile Anda
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1
          ? _buildMainContent() // Tampilkan konten utama untuk home
          : _buildProfilePage(), // Tampilkan halaman profile
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Custom App Bar with gradient
        Container(
          padding:
              const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Text(
                'Beranda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Grid Menu
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  title: 'MATERI',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.book_outlined,
                  color: Colors.blue[400]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuMateri()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: 'PRE TEST',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.quiz_outlined,
                  color: Colors.orange[400]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreTest()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: 'POST TEST',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.school_outlined,
                  color: Colors.purple[400]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostTest()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: 'VIDEO',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.play_circle_outline,
                  color: Colors.red[400]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoPage()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: 'DAFTAR PUSTAKA',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.library_books_outlined,
                  color: Colors.teal[400]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaftarPustaka()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: 'PETUNJUK PENGGUNA',
                  subtitle: 'klik untuk membuka',
                  icon: Icons.help_outline,
                  color: Colors.amber[600]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PetunjukPengguna()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Bottom Navigation Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.logout,
                label: 'LOGOUT',
                onTap: () {
                  // Show logout confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      );
                    },
                  );
                },
                isSelected: false,
              ),
              _buildNavItem(
                icon: Icons.home,
                label: 'HOME',
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                isSelected: _selectedIndex == 1,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'PROFIL',
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                isSelected: _selectedIndex == 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue[400] : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue[400] : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
