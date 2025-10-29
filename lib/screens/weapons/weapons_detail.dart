import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/weapons_model.dart';

class WeaponDetailPage extends StatefulWidget {
  final WeaponsModel weapon;

  const WeaponDetailPage({super.key, required this.weapon});

  @override
  State<WeaponDetailPage> createState() => _WeaponDetailPageState();
}

class _WeaponDetailPageState extends State<WeaponDetailPage> {
  late Skin _selectedSkin;
  late List<Skin> _availableSkins;

  @override
  void initState() {
    super.initState();
    _availableSkins = widget.weapon.skins
        .where(
          (skin) => skin.displayIcon != null && skin.displayIcon!.isNotEmpty,
        )
        .toList();

    if (_availableSkins.isNotEmpty) {
      _selectedSkin = _availableSkins.first;
    } else {
      _selectedSkin = widget.weapon.skins.first;
    }
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
    final String mainImageUrl = _selectedSkin.displayIcon ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.weapon.displayName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Tungsten-Bold',
            fontSize: 30,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedSkin.displayName.toUpperCase(),
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
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _availableSkins.length,
                        itemBuilder: (context, index) {
                          final skin = _availableSkins[index];
                          final bool isSelected =
                              skin.uuid == _selectedSkin.uuid;
                          final String thumbnailUrl = skin.displayIcon ?? '';

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
                          print("Equipping: ${_selectedSkin.displayName}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4655),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "BUY",
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
      ),
    );
  }
}
