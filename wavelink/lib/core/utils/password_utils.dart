import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

/// ===========================================================
///  PASSWORD VERIFY — Handles PBKDF2, rejects Scrypt safely
/// ===========================================================
Future<bool> checkPasswordHash(String password, String storedHash) async {
  try {
    if (storedHash.startsWith("pbkdf2:sha256")) {
      return await _verifyPbkdf2(password, storedHash);
    }

    print("❌ Scrypt detected. Convert this user to PBKDF2.");
    return false;
  } catch (e) {
    print("❌ Password verification error: $e");
    return false;
  }
}

/// PBKDF2 HMAC-SHA256 verification (Werkzeug-compatible)
Future<bool> _verifyPbkdf2(String password, String fullHash) async {
  final parts = fullHash.split("\$");
  if (parts.length != 3) return false;

  final method = parts[0]; // pbkdf2:sha256:260000
  final salt = parts[1];
  final expectedHash = parts[2];

  final methodParts = method.split(":");
  final iterations = int.tryParse(methodParts[2]) ?? 260000;

  final algo = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: expectedHash.length * 4, // hex → bits
  );

  final newKey = await algo.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: utf8.encode(salt),
  );

  final newHash = hex.encode(await newKey.extractBytes());

  return constantTimeCompare(newHash, expectedHash);
}

/// ===========================================================
///  PASSWORD HASH — Called when creating a new account
///  Returns:  pbkdf2:sha256:260000$salt$hexhash
/// ===========================================================
Future<String> hashPassword(String password) async {
  const iterations = 260000;
  final salt = _generateSalt(16);

  final algo = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  );

  final key = await algo.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: utf8.encode(salt),
  );

  final hash = hex.encode(await key.extractBytes());

  return "pbkdf2:sha256:$iterations\$$salt\$$hash";
}

/// Create ASCII salt
String _generateSalt(int length) {
  const chars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  final now = DateTime.now().microsecondsSinceEpoch;

  final buffer = StringBuffer();
  for (int i = 0; i < length; i++) {
    buffer.write(chars[(now + i * 37) % chars.length]);
  }
  return buffer.toString();
}

/// Constant-time string comparison
bool constantTimeCompare(String a, String b) {
  if (a.length != b.length) return false;
  int diff = 0;
  for (int i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}
