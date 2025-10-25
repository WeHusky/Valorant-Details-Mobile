import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowTopupPage extends StatefulWidget {
  const ShowTopupPage({super.key});

  @override
  State<ShowTopupPage> createState() => _ShowTopupPageState();
}

class _ShowTopupPageState extends State<ShowTopupPage> {
  String selectedCurrency = 'IDR';

  // Exchange rates (approximate values)
  final Map<String, double> exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000064, // 1 IDR = 0.000064 USD
    'SGD': 0.000085, // 1 IDR = 0.000085 SGD
    'MYR': 0.0003, // 1 IDR = 0.0003 MYR
  };

  final List<TopupPackage> packages = [
    TopupPackage(vp: 475, priceIdr: 56000),
    TopupPackage(vp: 1000, priceIdr: 112000),
    TopupPackage(vp: 2050, priceIdr: 224000),
    TopupPackage(vp: 3650, priceIdr: 389000),
    TopupPackage(vp: 5350, priceIdr: 559000),
    TopupPackage(vp: 11000, priceIdr: 1099000),
  ];

  String formatPrice(double price) {
    switch (selectedCurrency) {
      case 'IDR':
        return 'Rp. ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'SGD':
        return 'S\$${price.toStringAsFixed(2)}';
      case 'MYR':
        return 'MYR ${price.toStringAsFixed(2)}';
      default:
        return 'Rp. ${price.toStringAsFixed(0)}';
    }
  }

  double convertPrice(int priceIdr) {
    return priceIdr * exchangeRates[selectedCurrency]!;
  }

  void _showCurrencyDialog(BuildContext context, TopupPackage package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1F2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Mata Uang',
                      style: GoogleFonts.rajdhani(
                        fontSize: 24,
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
                const SizedBox(height: 20),
                Text(
                  '${package.vp} VP',
                  style: GoogleFonts.rajdhani(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF4655),
                  ),
                ),
                const SizedBox(height: 20),
                ...['IDR', 'USD', 'SGD', 'MYR'].map((currency) {
                  // Calculate price for this specific currency
                  final convertedPrice =
                      package.priceIdr * exchangeRates[currency]!;

                  // Format price for this specific currency
                  String displayPrice;
                  switch (currency) {
                    case 'IDR':
                      displayPrice =
                          'Rp. ${convertedPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
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
                      displayPrice = 'Rp. ${convertedPrice.toStringAsFixed(0)}';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCurrency = currency;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selectedCurrency == currency
                              ? const Color(0xFFFF4655).withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedCurrency == currency
                                ? const Color(0xFFFF4655)
                                : Colors.white.withOpacity(0.1),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current currency indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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

              // VP Packages Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final package = packages[index];
                    return _buildTopupCard(package);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopupCard(TopupPackage package) {
    return GestureDetector(
      onTap: () => _showCurrencyDialog(context, package),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
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
              // VP Amount
              Column(
                children: [
                  Text(
                    '${package.vp}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: Image.asset('assets/images/vp.png'),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),

              // Info Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4655).withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFF4655), width: 2),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFFF4655),
                  size: 20,
                ),
              ),

              // Price
              Column(
                children: [
                  Text(
                    'Mulai dari',
                    style: GoogleFonts.rajdhani(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopupPackage {
  final int vp;
  final int priceIdr;

  TopupPackage({required this.vp, required this.priceIdr});
}
