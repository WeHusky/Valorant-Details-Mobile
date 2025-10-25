import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/model/bundles_models.dart';
import 'package:tugas_akhir_valorant/services/bundles_services.dart';
import 'package:tugas_akhir_valorant/screens/bundles/bundles_details.dart';

class ShowBundlesPage extends StatefulWidget {
  const ShowBundlesPage({super.key});

  @override
  State<ShowBundlesPage> createState() => _ShowBundlesPageState();
}

class _ShowBundlesPageState extends State<ShowBundlesPage> {
  late Future<List<BundlesModel>> _futureBundles;

  @override
  void initState() {
    super.initState();
    _futureBundles = BundlesService().fetchBundles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        title: const Text(
          "BUNDLES",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<BundlesModel>>(
        future: _futureBundles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4655)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load bundles.",
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
                "No bundles found.",
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Teko',
                  fontSize: 22,
                ),
              ),
            );
          }

          final bundles = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
            ),
            itemCount: bundles.length,
            itemBuilder: (context, index) {
              final bundle = bundles[index];
              final imageUrl = bundle.displayIcon.isNotEmpty
                  ? bundle.displayIcon
                  : bundle.verticalPromoImage;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BundleDetailPage(bundle: bundle),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2332),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Gambar bundle
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.black12,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.white30,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                )
                              : Container(
                                  color: Colors.black12,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.white30,
                                      size: 40,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      // Nama bundle dan harga
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bundle.displayName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Teko',
                                  fontSize: 20,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(
                                    0xFFFF4655,
                                  ).withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF4655,
                                      ).withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1.5,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFFFF4655),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "5010 VP",
                                      style: TextStyle(
                                        fontFamily: 'Teko',
                                        fontSize: 18,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
            },
          );
        },
      ),
    );
  }
}
