import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tugas_akhir_valorant/model/teams_models.dart';
import 'package:tugas_akhir_valorant/services/teams_services.dart';
import 'package:tugas_akhir_valorant/services/location_services.dart';

class ShowTeamsPage extends StatefulWidget {
  const ShowTeamsPage({super.key});

  @override
  State<ShowTeamsPage> createState() => _ShowTeamsPageState();
}

class _ShowTeamsPageState extends State<ShowTeamsPage> {
  Future<Map<String, List<TeamModel>>>? _teamsFuture;
  final TeamsService _teamsService = TeamsService();
  String _userRegion = "Unknown";
  String _userCountry = "Mendeteksi lokasi...";

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    await _detectRegionFromLocation();
    setState(() {
      _teamsFuture = _teamsService.fetchTeamsByRegion();
    });
  }

  /// 🔹 Gunakan LocationService untuk ambil posisi & tentukan region
  Future<void> _detectRegionFromLocation() async {
    try {
      final position = await LocationService.getUserLocation();
      if (position == null) {
        setState(() => _userCountry = "Tidak dapat mendeteksi lokasi");
        return;
      }

      final country = await LocationService.getCountryFromPosition(position);
      if (country == null) {
        setState(() => _userCountry = "Negara tidak terdeteksi");
        return;
      }

      // Tentukan region berdasarkan negara
      String region;
      if (country.toLowerCase().contains("indonesia")) {
        region = "APAC";
      } else if (country.toLowerCase().contains("united states") ||
          country.toLowerCase().contains("canada")) {
        region = "Americas";
      } else if (country.toLowerCase().contains("france") ||
          country.toLowerCase().contains("germany")) {
        region = "EMEA";
      } else {
        region = "Unknown Region";
      }

      setState(() {
        _userCountry = country;
        _userRegion = region;
      });

      print("📍 Country: $country → Region: $_userRegion");
    } catch (e) {
      print("❌ Gagal mendapatkan lokasi: $e");
      setState(() => _userCountry = "Error lokasi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "VCT TEAMS",
          style: TextStyle(
            fontFamily: 'Tungsten',
            fontSize: 38,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: _teamsFuture == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4655)),
            )
          : FutureBuilder<Map<String, List<TeamModel>>>(
              future: _teamsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF4655)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat tim: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'Tidak ada data tim.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final teamsByRegion = snapshot.data!;

                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    // 🔹 Info lokasi pengguna di atas
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFF4655).withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFFF4655),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Lokasi kamu: $_userCountry → Region kamu: $_userRegion",
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Rajdhani',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Daftar tim per region
                    ...teamsByRegion.entries.map((entry) {
                      final regionName = entry.key;
                      final teams = entry.value;
                      if (teams.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              regionName.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Tungsten',
                                fontSize: 28,
                                color: Color(0xFFFF4655),
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: teams.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final team = teams[index];
                                return _buildTeamCard(team);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }

  /// 🔹 Widget kartu tim
  Widget _buildTeamCard(TeamModel team) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF4655).withOpacity(0.4),
          width: 1.3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              team.img,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                color: Colors.white38,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            team.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tungsten',
              fontSize: 24,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          Text(
            team.country,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 15,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
