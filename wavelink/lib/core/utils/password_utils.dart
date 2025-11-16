import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

/// Master verification for both PBKDF2 and Scrypt (detected)
Future<bool> checkPasswordHash(String password, String storedHash) async {
  try {
    if (storedHash.startsWith("pbkdf2:sha256")) {
      return await _verifyPbkdf2Hash(password, storedHash);
    }

    if (storedHash.startsWith("scrypt:")) {
      print("❌ Scrypt detected - Flutter cannot verify this hash.");
      print("❗ User must reset password (convert to PBKDF2).");
      return false;
    }

    print("❌ Unknown hash format: $storedHash");
    return false;
  } catch (e) {
    print("❌ Error verifying password: $e");
    return false;
  }
}

/// PBKDF2 verification
Future<bool> _verifyPbkdf2Hash(String password, String fullHash) async {
  final parts = fullHash.split('\$');
  if (parts.length != 3) {
    print("❌ Invalid PBKDF2 format");
    return false;
  }

  final method = parts[0];       // pbkdf2:sha256:260000
  final salt = parts[1];
  final expectedHash = parts[2];

  final methodParts = method.split(':');
  final iterations = int.parse(methodParts[2]);

  // Werkzeug: hex hash length → bits
  final hashBytes = expectedHash.length ~/ 2;
  final bitLength = hashBytes * 8;

  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: bitLength,
  );

  final secretKey = SecretKey(utf8.encode(password));
  final nonce = utf8.encode(salt);

  final newKey = await pbkdf2.deriveKey(
    secretKey: secretKey,
    nonce: nonce,
  );

  final newHashBytes = await newKey.extractBytes();
  final newHashHex = hex.encode(newHashBytes);

  return _constantTimeCompare(newHashHex, expectedHash);
}

/// Constant-time compare
bool _constantTimeCompare(String a, String b) {
  if (a.length != b.length) return false;
  int diff = 0;
  for (int i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}
