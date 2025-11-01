import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir_valorant/database/db_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tugas_akhir_valorant/services/notification_service.dart';

class ShowTopupPage extends StatefulWidget {
  const ShowTopupPage({super.key});

  @override
  State<ShowTopupPage> createState() => _ShowTopupPageState();
}

class _ShowTopupPageState extends State<ShowTopupPage> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isDenied) {
      // Pengguna menolak izin, Anda bisa menampilkan dialog penjelasan di sini jika perlu.
    }
  }

  // Mata uang aktif
  String selectedCurrency = 'IDR';

  // Nilai tukar sederhana
  final Map<String, double> exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000064,
    'SGD': 0.000085,
    'MYR': 0.0003,
  };

  // Daftar paket top-up
  final List<TopupPackage> topupPackages = [
    TopupPackage(vp: 475, priceIdr: 56000),
    TopupPackage(vp: 1000, priceIdr: 112000),
    TopupPackage(vp: 2050, priceIdr: 224000),
    TopupPackage(vp: 3650, priceIdr: 389000),
    TopupPackage(vp: 5350, priceIdr: 559000),
    TopupPackage(vp: 11000, priceIdr: 1099000),
  ];

  // Format harga berdasarkan mata uang
  String formatPrice(double price) {
    switch (selectedCurrency) {
      case 'IDR':
        return 'Rp. ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'SGD':
        return 'S\$${price.toStringAsFixed(2)}';
      case 'MYR':
        return 'MYR ${price.toStringAsFixed(2)}';
      default:
        return price.toString();
    }
  }

  // Konversi harga IDR ke mata uang lain
  double convertPrice(int priceIdr) {
    return priceIdr * exchangeRates[selectedCurrency]!;
  }

  // Dialog pilih mata uang
  void showCurrencyDialog(TopupPackage package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1F2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Mata Uang',
                      style: GoogleFonts.rajdhani(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${package.vp} VP',
                  style: GoogleFonts.rajdhani(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF4655),
                  ),
                ),
                const SizedBox(height: 16),

                // Pilihan mata uang
                ...exchangeRates.keys.map((currency) {
                  final convertedPrice =
                      package.priceIdr * exchangeRates[currency]!;
                  String displayPrice;

                  switch (currency) {
                    case 'IDR':
                      displayPrice =
                          'Rp. ${convertedPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
                      break;
                    case 'USD':
                      displayPrice = '\$${convertedPrice.toStringAsFixed(2)}';
                      break;
                    case 'SGD':
                      displayPrice = 'S\$${convertedPrice.toStringAsFixed(2)}';
                      break;
                    case 'MYR':
                      displayPrice = 'MYR ${convertedPrice.toStringAsFixed(2)}';
                      break;
                    default:
                      displayPrice = convertedPrice.toString();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCurrency = currency;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selectedCurrency == currency
                              ? const Color(0xFFFF4655).withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedCurrency == currency
                                ? const Color(0xFFFF4655)
                                : Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currency,
                              style: GoogleFonts.rajdhani(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              displayPrice,
                              style: GoogleFonts.rajdhani(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: selectedCurrency == currency
                                    ? Colors.white
                                    : const Color(0xFFFF4655),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // UI utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TOP UP VP',
          style: GoogleFonts.rajdhani(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info mata uang aktif
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4655).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF4655),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language,
                      color: Color(0xFFFF4655),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mata Uang: $selectedCurrency',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Grid paket top-up
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: topupPackages.length,
                  itemBuilder: (context, index) {
                    final package = topupPackages[index];
                    return buildTopupCard(package);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kartu topup
  Widget buildTopupCard(TopupPackage package) {
    return GestureDetector(
      onTap: () => showCurrencyDialog(package),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF4655).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian atas
              Column(
                children: [
                  Text(
                    '${package.vp}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset('assets/images/vp.png', width: 40, height: 40),
                ],
              ),

              // Harga & tombol beli
              Column(
                children: [
                  Text(
                    'Mulai dari',
                    style: GoogleFonts.rajdhani(
                      fontSize: 12,
                      color: const Color(0xFFFF4655).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(convertPrice(package.priceIdr)),
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF4655),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4655),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () async {
                      final db = DBHelper();
                      await db.insertTransaction({
                        'vp': package.vp,
                        'price': formatPrice(convertPrice(package.priceIdr)),
                        'currency': selectedCurrency,
                        'time': DateTime.now().toIso8601String(),
                      });

                      _notificationService.showTopupSuccessNotification(
                        package.vp,
                      );
                    },
                    child: Text(
                      'Buy',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model paket topup
class TopupPackage {
  final int vp;
  final int priceIdr;

  TopupPackage({required this.vp, required this.priceIdr});
}
