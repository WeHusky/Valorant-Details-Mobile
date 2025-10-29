import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/screens/agents/show_agents.dart';
import 'package:tugas_akhir_valorant/screens/weapons/show_weapons.dart';
import 'package:tugas_akhir_valorant/screens/bundles/show_bundles.dart';
import 'package:tugas_akhir_valorant/screens/topup/topup.dart';
import 'package:tugas_akhir_valorant/screens/teams/show_teams.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0F1823).withOpacity(0.9),
                      const Color(0xFF330C1C).withOpacity(0.85),
                      const Color(0xFFBD3944).withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/map split.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "VALORANT",
                    style: TextStyle(
                      fontFamily: 'Valorant',
                      fontSize: 64,
                      letterSpacing: 4,
                      color: Color(0xFFFF4655),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildMenuCard(
                          context,
                          title: "AGENTS",
                          icon: Icons.people_alt_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShowAgentPage(),
                              ),
                            );
                          },
                        ),
                        _buildMenuCard(
                          context,
                          title: "WEAPONS",
                          icon: Icons.local_fire_department_outlined,
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
                          icon: Icons.shopping_bag_outlined,
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
                          title: "TOP UP",
                          icon: Icons.monetization_on_outlined,
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
                          title: "REGIONS",
                          icon: Icons.public_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShowTeamsPage(),
                              ),
                            );
                          },
                        ),
                        _buildMenuCard(
                          context,
                          title: "USER INFO",
                          icon: Icons.person,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFF4655), size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Teko',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
