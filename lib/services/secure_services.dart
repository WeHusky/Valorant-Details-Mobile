// lib/services/secure_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

/// SecureStore
/// - Menyimpan kunci/secret secara terenkripsi menggunakan flutter_secure_storage
/// - Kita menggunakan AES (encrypt package) untuk enkripsi tambahan sebelum menyimpan.
/// - NOTE: kunci AES statis di code hanya untuk demo. Untuk produksi, gunakan
///   key management yang lebih aman (keystore, server-side, atau mendapat input user).
class SecureStore {
  static final _storage = const FlutterSecureStorage();

  // WARNING: untuk demo. di produksi jangan hardcode secret key,
  // gunakan keystore/platform-specific secure key derivation.
  static final _aesKey = Key.fromUtf8(
    'paruguard_demo_32bytes_secretkey', // Corrected to 32 characters
  ); // 32 chars/bytes for AES-256

  static final _encrypter = Encrypter(AES(_aesKey, mode: AESMode.cbc));

  /// Write value (encrypted) into secure storage
  static Future<void> writeEncrypted(String key, String value) async {
    final iv = IV.fromLength(16);
    final encrypted = _encrypter.encrypt(value, iv: iv);
    await _storage.write(key: key, value: encrypted.base64);
  }

  /// Read and decrypt value
  static Future<String?> readEncrypted(String key) async {
    final base64 = await _storage.read(key: key);
    if (base64 == null) return null;
    final encrypted = Encrypted.fromBase64(base64);
    final iv = IV.fromLength(16);
    final decrypted = _encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  /// Delete key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
