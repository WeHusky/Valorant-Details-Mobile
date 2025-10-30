import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/screens/login_register_page.dart';
import 'package:tugas_akhir_valorant/screens/homepage.dart';
import 'package:tugas_akhir_valorant/services/secure_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SecureStore.readEncrypted('user_session'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Jika ada sesi (tidak null dan tidak kosong), masuk ke HomePage
        return (snapshot.hasData && snapshot.data!.isNotEmpty)
            ? const HomePage()
            : const LoginRegisterPage();
      },
    );
  }
}
