import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aplikasi_elearning/material_list_screen.dart';
import 'package:aplikasi_elearning/auth/login_screen.dart';
import 'package:aplikasi_elearning/pre_test.dart';
import 'package:aplikasi_elearning/post_test.dart';
import 'package:aplikasi_elearning/video_page.dart';
import 'package:aplikasi_elearning/daftar_pustaka.dart';
import 'package:aplikasi_elearning/petunjuk_pengguna.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _selectedIndex == 1 ? _buildMainContent() : _buildProfilePage(),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Text('Profile Page'),
    );
  }

  Widget _buildMainContent() {
    return Container(
      color: Colors.white, // Tambahkan ini
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildGridMenu(),
          const SizedBox(height: 20),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Text(
              'Selamat Datang!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
            subtitle: Text(
              'E-Learning App',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white54),
            ),
            trailing: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget _buildGridMenu() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(200),
          ),
        ),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 30,
          children: [
            _buildMenuItem(
              'Materi',
              CupertinoIcons.book,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MaterialListScreen()),
              ),
            ),
            _buildMenuItem(
              'Pre Test',
              CupertinoIcons.doc_text,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreTestScreen()),
              ),
            ),
            _buildMenuItem(
              'Post Test',
              CupertinoIcons.doc_chart,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostTestScreen()),
              ),
            ),
            _buildMenuItem(
              'Video',
              CupertinoIcons.play_rectangle,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPage()),
              ),
            ),
            _buildMenuItem(
              'Daftar Pustaka',
              CupertinoIcons.book_circle,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DaftarPustaka()),
              ),
            ),
            _buildMenuItem(
              'Petunjuk',
              CupertinoIcons.question_circle,
              Colors.amber,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetunjukPengguna()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String title, IconData iconData, Color background, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
            onTap: () => _showLogoutDialog(),
            isSelected: false,
          ),
          _buildNavItem(
            icon: Icons.home,
            label: 'HOME',
            onTap: () => setState(() => _selectedIndex = 1),
            isSelected: _selectedIndex == 1,
          ),
          _buildNavItem(
            icon: Icons.person,
            label: 'PROFIL',
            onTap: () => setState(() => _selectedIndex = 2),
            isSelected: _selectedIndex == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
