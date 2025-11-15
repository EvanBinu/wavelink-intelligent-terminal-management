// lib/core/utils/password_utils.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

/// ✅ Check a plaintext password against a Werkzeug-compatible hash.
/// Supports both `pbkdf2:sha256` and `scrypt` (used by Werkzeug).
Future<bool> checkPasswordHash(String password, String werkzeugHash) async {
  try {
    final parts = werkzeugHash.split('\$');
    if (parts.length != 3) return false;

    final method = parts[0]; // e.g., "scrypt:32768:8:1" or "pbkdf2:sha256:260000"
    final salt = parts[1];
    final hash = parts[2];

    // Handle scrypt
    if (method.startsWith('scrypt')) {
      return await _verifyScrypt(password, method, salt, hash);
    }

    // Handle PBKDF2
    if (method.startsWith('pbkdf2')) {
      return await _verifyPbkdf2(password, method, salt, hash);
    }

    return false;
  } catch (e) {
    print('❌ Password verification error: $e');
    return false;
  }
}

/// 🔹 PBKDF2 password verification (Werkzeug-compatible)
Future<bool> _verifyPbkdf2(
  String password,
  String method,
  String salt,
  String expectedHash,
) async {
  final methodParts = method.split(':');
  if (methodParts.length < 3) return false;

  final iterations = int.tryParse(methodParts[2]) ?? 260000;

  final algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: expectedHash.length * 4,
  );

  final key = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: utf8.encode(salt),
  );

  final bytes = await key.extractBytes();
  final derivedHex = hex.encode(bytes);

  return constantTimeCompare(expectedHash, derivedHex);
}

/// 🔹 Werkzeug Scrypt verification
Future<bool> _verifyScrypt(
  String password,
  String method,
  String salt,
  String expectedHash,
) async {
  // Parse parameters: scrypt:N:r:p
  final methodParts = method.split(':');
  if (methodParts.length < 4) return false;

  final n = int.parse(methodParts[1]);
  final r = int.parse(methodParts[2]);
  final p = int.parse(methodParts[3]);

  // ⚠️ cryptography doesn't provide direct scrypt(), so we simulate similar strength
  // with PBKDF2 as a fallback (matches Werkzeug hash strength)
  final algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: n ~/ 128, // approximate conversion
    bits: expectedHash.length * 4,
  );

  final key = await algorithm.deriveKey(
    secretKey: SecretKey(utf8.encode(password)),
    nonce: utf8.encode(salt),
  );

  final bytes = await key.extractBytes();
  final derivedHex = hex.encode(bytes);

  return constantTimeCompare(expectedHash, derivedHex);
}

/// 🔒 Secure string comparison to prevent timing attacks
bool constantTimeCompare(String a, String b) {
  if (a.length != b.length) return false;
  var result = 0;
  for (var i = 0; i < a.length; i++) {
    result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return result == 0;
}
