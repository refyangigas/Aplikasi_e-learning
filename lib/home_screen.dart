import 'package:flutter/material.dart';
import 'package:aplikasi_elearning/menu_materi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                Icon(Icons.menu, color: Colors.white, size: 28),
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
                        MaterialPageRoute(
                          builder: (context) => MenuMateri(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    title: 'PRE TEST',
                    subtitle: 'klik untuk membuka',
                    icon: Icons.quiz_outlined,
                    color: Colors.orange[400]!,
                    onTap: () {
                      // Handle pre test tap
                    },
                  ),
                  _buildMenuCard(
                    title: 'POST TEST',
                    subtitle: 'klik untuk membuka',
                    icon: Icons.school_outlined,
                    color: Colors.purple[400]!,
                    onTap: () {
                      // Handle post test tap
                    },
                  ),
                  _buildMenuCard(
                    title: 'VIDEO',
                    subtitle: 'klik untuk membuka',
                    icon: Icons.play_circle_outline,
                    color: Colors.red[400]!,
                    onTap: () {
                      // Handle video tap
                    },
                  ),
                  _buildMenuCard(
                    title: 'DAFTAR PUSTAKA',
                    subtitle: 'klik untuk membuka',
                    icon: Icons.library_books_outlined,
                    color: Colors.teal[400]!,
                    onTap: () {
                      // Handle daftar pustaka tap
                    },
                  ),
                  _buildMenuCard(
                    title: 'PETUNJUK PENGGUNA',
                    subtitle: 'klik untuk membuka',
                    icon: Icons.help_outline,
                    color: Colors.amber[600]!,
                    onTap: () {
                      // Handle petunjuk pengguna tap
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
                      // Handle logout
                    }),
                _buildNavItem(
                    icon: Icons.home,
                    label: 'HOME',
                    onTap: () {
                      // Handle home
                    },
                    isSelected: true),
                _buildNavItem(
                    icon: Icons.person,
                    label: 'PROFIL',
                    onTap: () {
                      // Handle profile
                    }),
              ],
            ),
          ),
        ],
      ),
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
