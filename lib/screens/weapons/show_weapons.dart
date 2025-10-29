import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/weapons_model.dart';
import 'package:tugas_akhir_valorant/services/weapons_services.dart';
import 'package:tugas_akhir_valorant/screens/weapons/weapons_detail.dart';

class ShowWeaponPage extends StatefulWidget {
  const ShowWeaponPage({super.key});

  @override
  State<ShowWeaponPage> createState() => _ShowWeaponPageState();
}

class _ShowWeaponPageState extends State<ShowWeaponPage> {
  final WeaponService _weaponService = WeaponService();

  late Future<List<WeaponsModel>> _futureWeapons;

  final TextEditingController searchTextController = TextEditingController();

  List<WeaponsModel> allWeapons = [];
  List<WeaponsModel> filteredWeapons = [];

  @override
  void initState() {
    super.initState();
    _futureWeapons = _weaponService.getWeapons();
    _loadWeapons();
    searchTextController.addListener(_applySearchFilter);
  }

  /// Ambil data senjata dari API dan simpan di state
  Future<void> _loadWeapons() async {
    final weaponsData = await _weaponService.getWeapons();
    setState(() {
      allWeapons = weaponsData;
      filteredWeapons = weaponsData;
    });
  }

  /// Filter senjata berdasarkan input pengguna
  void _applySearchFilter() {
    final query = searchTextController.text.toLowerCase();

    setState(() {
      filteredWeapons = allWeapons.where((weapon) {
        return weapon.displayName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
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
        future: _futureWeapons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4655)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: filteredWeapons.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada senjata ditemukan.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : _buildWeaponList(filteredWeapons),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔍 Widget search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchTextController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari senjata...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1B252F),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFFFF4655), width: 2),
          ),
        ),
      ),
    );
  }

  /// 🧱 Widget untuk menampilkan daftar senjata (tergrup per kategori)
  Widget _buildWeaponList(List<WeaponsModel> weapons) {
    // Kelompokkan berdasarkan kategori
    final Map<String, List<WeaponsModel>> weaponsByCategory = {};
    for (var weapon in weapons) {
      weaponsByCategory.putIfAbsent(weapon.category, () => []).add(weapon);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: weaponsByCategory.entries.map((entry) {
        final categoryLabel = entry.key
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
              // 🏷️ Nama kategori
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  categoryLabel,
                  style: const TextStyle(
                    fontFamily: 'Teko',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF4655),
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // 🔫 Grid senjata per kategori
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryWeapons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final weapon = categoryWeapons[index];
                  return _buildWeaponCard(weapon);
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 💥 Widget kartu individual senjata
  Widget _buildWeaponCard(WeaponsModel weapon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeaponDetailPage(weapon: weapon),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar senjata
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(
                  weapon.displayIcon,
                  fit: BoxFit.contain,
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

            // Nama senjata
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4655).withOpacity(0.9),
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
  }
}
