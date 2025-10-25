import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant Agents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1923),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2326),
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4655),
          secondary: Color(0xFF1F2326),
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      routes: {'/agents': (context) => const HomePage()},
    );
  }
}
