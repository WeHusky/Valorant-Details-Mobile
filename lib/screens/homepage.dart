import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/screens/agents/show_agents.dart';
import 'package:tugas_akhir_valorant/screens/weapons/show_weapons.dart';
import 'package:tugas_akhir_valorant/screens/bundles/show_bundles.dart';
import 'package:tugas_akhir_valorant/screens/topup/topup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "VALORANT DATABASE",
                style: TextStyle(
                  fontFamily: 'Teko',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50),

              // Grid menu
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildMenuCard(
                      context,
                      title: "AGENTS",
                      image:
                          "https://static.wikia.nocookie.net/valorant/images/3/3e/Brimstone_artwork.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowAgentsPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: "WEAPONS",
                      image:
                          "https://static.wikia.nocookie.net/valorant/images/2/2a/Vandal_valorant.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowWeaponPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: "BUNDLES",
                      image:
                          "https://static.wikia.nocookie.net/valorant/images/3/3e/Brimstone_artwork.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowBundlesPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: "TOPUP",
                      image:
                          "https://static.wikia.nocookie.net/valorant/images/3/3e/Brimstone_artwork.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowTopupPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      context,
                      title: "CEK REGION",
                      image:
                          "https://static.wikia.nocookie.net/valorant/images/3/3e/Brimstone_artwork.png",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF4655).withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.35),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Teko',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
