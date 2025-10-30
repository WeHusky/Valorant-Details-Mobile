import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "PROFIL SAYA",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundColor: Color(0xFFFF4655),
                child: CircleAvatar(
                  radius: 76,
                  // Pastikan Anda memiliki gambar 'profile.png' di folder assets/images/
                  backgroundImage: AssetImage('assets/images/profil.jpg'),
                  backgroundColor: Color(0xFF1B252F),
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoCard(
                icon: Icons.person_outline,
                title: "Nama",
                value: "Muhammad Sulthan Al Azzam", 
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.badge_outlined,
                title: "NIM",
                value: "124230127", 
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.school_outlined,
                title: "Kelas",
                value: "PAM-A", 
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.favorite_border,
                title: "Hobi",
                value: "Bermain Game & Ngoding", 
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.favorite_border,
                title: "Favorit Lagu",
                value: "If I Had A Gun...", 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF4655), size: 28),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
