import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/bundles_models.dart';
import 'package:tugas_akhir_valorant/model/weapons_model.dart';
import 'package:tugas_akhir_valorant/services/weapons_services.dart';

class BundleDetailPage extends StatefulWidget {
  final BundlesModel bundle;

  const BundleDetailPage({super.key, required this.bundle});

  @override
  State<BundleDetailPage> createState() => _BundleDetailPageState();
}

class _BundleDetailPageState extends State<BundleDetailPage> {
  late Future<List<WeaponsModel>> _futureWeapons;
  Skin? _selectedSkin;
  List<Skin> _availableSkins = [];

  @override
  void initState() {
    super.initState();
    _futureWeapons = WeaponService().getWeapons();
  }

  List<Skin> _filterSkinsByBundleName(List<WeaponsModel> weapons) {
    final List<Skin> matchedSkins = [];
    final String bundleName = widget.bundle.displayName.toUpperCase();

    for (var weapon in weapons) {
      for (var skin in weapon.skins) {
        if (skin.displayName.toUpperCase().contains(bundleName)) {
          matchedSkins.add(skin);
        }
      }
    }

    return matchedSkins;
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: Colors.white.withOpacity(0.05),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white30,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildImageLoadingIndicator(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFFF4655)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.bundle.displayName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Tungsten-Bold',
            fontSize: 30,
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load skins.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Teko',
                  fontSize: 20,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No weapons found.",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Teko',
                  fontSize: 22,
                ),
              ),
            );
          }

          _availableSkins = _filterSkinsByBundleName(snapshot.data!)
              .where(
                (skin) =>
                    skin.displayIcon != null && skin.displayIcon!.isNotEmpty,
              )
              .toList();

          if (_availableSkins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No matching skins found",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'Teko',
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "for ${widget.bundle.displayName}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontFamily: 'Teko',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          // Initialize selected skin if not set
          if (!mounted) return const SizedBox.shrink();
          if (_selectedSkin == null && _availableSkins.isNotEmpty) {
            _selectedSkin = _availableSkins.first;
          }

          if (_selectedSkin == null) {
            return const SizedBox.shrink();
          }

          final String mainImageUrl = _selectedSkin!.displayIcon ?? '';

          return SafeArea(
            child: Column(
              children: [
                // Gambar utama skin
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: mainImageUrl.isEmpty
                        ? _buildImageErrorPlaceholder()
                        : Image.network(
                            mainImageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: _buildImageLoadingIndicator,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImageErrorPlaceholder(),
                          ),
                  ),
                ),

                // Bagian bawah skin dan tombol
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedSkin!.displayName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Tungsten-Bold',
                            fontSize: 26,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "SKINS",
                          style: TextStyle(
                            fontFamily: 'Tungsten-Bold',
                            fontSize: 18,
                            letterSpacing: 1,
                            color: Color(0xFFFF4655),
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFFF4655),
                          thickness: 2,
                          endIndent: 250,
                        ),
                        const SizedBox(height: 10),

                        // Horizontal scroll list
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _availableSkins.length,
                            itemBuilder: (context, index) {
                              final skin = _availableSkins[index];
                              final bool isSelected =
                                  skin.uuid == _selectedSkin?.uuid;
                              final String thumbnailUrl =
                                  skin.displayIcon ?? '';

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSkin = skin;
                                  });
                                },
                                child: Container(
                                  width: 90,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFFF4655)
                                          : Colors.white.withOpacity(0.2),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: thumbnailUrl.isEmpty
                                        ? _buildImageErrorPlaceholder()
                                        : Image.network(
                                            thumbnailUrl,
                                            fit: BoxFit.contain,
                                            loadingBuilder:
                                                _buildImageLoadingIndicator,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    _buildImageErrorPlaceholder(),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Equipping: ${_selectedSkin!.displayName}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4655),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "BUY BUNDLES",
                              style: TextStyle(
                                fontFamily: 'Tungsten-Bold',
                                fontSize: 20,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
