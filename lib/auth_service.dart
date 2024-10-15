import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ssoauth/firebase_service.dart';

class AuthService {
  final FlutterAppAuth appAuth = const FlutterAppAuth();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String clientId = 'MpLWQNIg5cCyO90NIOSV4KTQiKf4REVd';
  static const String redirectUrl = 'com.example.ssoauth://login-callback';
  static const String issuer = 'https://dev-crnem0shb2y72h7g.us.auth0.com';
  static const String logoutUrl = 'com.example.ssoauth://logout-callback';
  List<String> scopes = ['openid', 'profile', 'email', "offline_access"];

  Future<void> signInWithOIDC() async {
    String nonce = randomNonceString();

    try {
      final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(clientId, redirectUrl, issuer: issuer, scopes: scopes, promptValues: ['login']),
      );

      print("log: ${result.accessToken}");
      print("log id: ${result.idToken}");

      final String? idToken = result.idToken;
      final String? accessToken = result.accessToken;

      if (idToken != null && accessToken != null) {
        final OAuthCredential credential =
            OAuthProvider('oidc.ssologin').credential(idToken: idToken, accessToken: accessToken, rawNonce: nonce);

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        print('User signed in: ${userCredential.user?.uid}');

        await _secureStorage.write(key: 'access_token', value: result.accessToken);
        await _secureStorage.write(key: 'id_token', value: result.idToken);
        await _secureStorage.write(key: 'refresh_token', value: result.refreshToken);

        await FirebaseService.instance.storeTokens(idToken, accessToken, "com.example.ssoauth");
      } else {
        print('Missing idToken or accessToken');
      }
    } catch (e) {
      print('Error during sign-in: $e');
    }
  }

  Future<void> logout() async {
    try {
      var appAuth = const FlutterAppAuth();
      final idToken = await _secureStorage.read(key: 'id_token');

      await appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          issuer: issuer,
          postLogoutRedirectUrl: logoutUrl,
        ),
      );

      FirebaseAuth.instance.signOut();
      await _secureStorage.deleteAll();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Generates a SHA-256 hash of the input string and returns it as a hexadecimal string.
  String sha256Hash(String input) {
    final bytes = utf8.encode(input);

    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Generates a random nonce string of specified length using a character set.
  String randomNonceString({int length = 32}) {
    assert(length > 0, 'Length must be greater than 0');

    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();

    return List.generate(length, (index) => charset[random.nextInt(charset.length)]).join();
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
}
