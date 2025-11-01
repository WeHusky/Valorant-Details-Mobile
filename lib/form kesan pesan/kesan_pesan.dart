import 'package:flutter/material.dart';
import 'package:tugas_akhir_valorant/database/db_helper.dart';

class KesanPesanPage extends StatefulWidget {
  const KesanPesanPage({super.key});

  @override
  State<KesanPesanPage> createState() => _KesanPesanPageState();
}

class _KesanPesanPageState extends State<KesanPesanPage> {
  final _formKey = GlobalKey<FormState>();
  final _kesanController = TextEditingController();
  final _pesanController = TextEditingController();

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DBHelper();
      await dbHelper.insertFeedback({
        'kesan': _kesanController.text,
        'pesan': _pesanController.text,
        'time': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terima kasih atas kesan dan pesannya!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    }
  }

  @override
  void dispose() {
    _kesanController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1823),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "KESAN & PESAN",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kesanController,
                decoration: _inputDecoration('Tulis kesan Anda...'),
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Kesan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _pesanController,
                decoration: _inputDecoration('Tulis pesan Anda...'),
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Pesan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4655),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "KIRIM",
                  style: TextStyle(
                    fontFamily: 'Teko',
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF4655)),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
