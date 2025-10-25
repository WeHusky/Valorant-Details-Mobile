import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/weapons_model.dart';
import 'package:tugas_akhir_valorant/services/weapons_services.dart';
// TAMBAHKAN IMPORT INI (sesuaikan path jika perlu)
import 'package:tugas_akhir_valorant/screens/weapons/weapons_detail.dart'; 

class ShowWeaponPage extends StatefulWidget {
  const ShowWeaponPage({super.key});

  @override
  State<ShowWeaponPage> createState() => _ShowWeaponPageState();
}

class _ShowWeaponPageState extends State<ShowWeaponPage> {
  late Future<List<WeaponsModel>> _weaponsFuture;
  final WeaponService _weaponService = WeaponService();

  @override
  void initState() {
    super.initState();
    _weaponsFuture = _weaponService.getWeapons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "VALORANT WEAPONS",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WeaponsModel>>(
        future: _weaponsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4655)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat senjata: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data senjata.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final weapons = snapshot.data!;

          // Group by category
          final Map<String, List<WeaponsModel>> groupedWeapons = {};
          for (var weapon in weapons) {
            groupedWeapons.putIfAbsent(weapon.category, () => []).add(weapon);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: groupedWeapons.entries.map((entry) {
              final categoryName = entry.key
                  .split("::")
                  .last
                  .toUpperCase()
                  .replaceAll("_", " ");
              final categoryWeapons = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontFamily: 'Teko',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF4655),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    // Weapon Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryWeapons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final weapon = categoryWeapons[index];

                        // --- MODIFIKASI DIMULAI DI SINI ---
                        return GestureDetector(
                          onTap: () {
                            // Aksi navigasi saat item diketuk
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeaponDetailPage(
                                  weapon: weapon, // Mengirim data senjata
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Image.network(
                                      weapon.displayIcon,
                                      fit: BoxFit.contain,
                                      // Tambahan untuk handle error & loading
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFF4655),
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.white.withOpacity(0.3),
                                          size: 40,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF4655,
                                    ).withOpacity(0.9),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    weapon.displayName.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Teko',
                                      fontSize: 20,
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        // --- MODIFIKASI BERAKHIR DI SINI ---
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}