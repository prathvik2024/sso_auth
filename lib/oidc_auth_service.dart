import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'models/auth0_id_token.dart';
import 'models/auth0_user.dart';

class OIDCAuthService {
  static final OIDCAuthService instance = OIDCAuthService._internal();

  factory OIDCAuthService() => instance;

  OIDCAuthService._internal();

  final String REFRESH_TOKEN_KEY = "refresh_token";
  final String ID_TOKEN_KEY = "id_token";
  final String AUTH0_CLIENT_ID = 'MpLWQNIg5cCyO90NIOSV4KTQiKf4REVd';
  final String AUTH0_DOMAIN = 'dev-crnem0shb2y72h7g.us.auth0.com';
  final String AUTH0_REDIRECT_URI = 'com.example.ssoauth://login-callback';
  final String AUTH0_ISSUER = 'https://dev-crnem0shb2y72h7g.us.auth0.com';
  final String AUTH0_LOGOUT_URL = 'com.example.ssoauth://logout-callback';
  final List<String> scopes = ['openid', 'profile', 'email', "offline_access"];
  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  AuthOUser? profile;
  AuthOIdToken? idToken;
  String? auth0AccessToken;

  Future<bool> init() async {
    final storedRefreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

    if (storedRefreshToken == null) {
      return false;
    }

    try {
      final TokenResponse? result = await appAuth.token(
        TokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: AUTH0_ISSUER,
          refreshToken: storedRefreshToken,
        ),
      );
      log("log: ${result}");
      final bool setResult = await _setLocalVariables(result);
      return setResult;
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      // logOut() possibly
      return false;
    }
  }

  Future<bool> login() async {
    try {
      final authorizationTokenRequest = AuthorizationTokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        scopes: ['openid', 'profile', 'offline_access', 'email'],
        promptValues: ['login'],
      );

      final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
        authorizationTokenRequest,
      );

      return await _setLocalVariables(result);
    } on PlatformException {
      log("log: User has cancelled or no internet!");
      return false;
    } catch (e, s) {
      print('log: Login Uknown erorr $e, $s');
      return false;
    }
  }

  AuthOIdToken parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );
    log("log: idTokenParse: ${json}");

    return AuthOIdToken.fromJson(json);
  }

  Future<AuthOUser?> getUserDetails(String accessToken) async {
    final url = Uri.https(
      AUTH0_DOMAIN,
      '/userinfo',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      log("log: userDetails: ${response.body}");
      return AuthOUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<bool> _setLocalVariables(result) async {
    final bool isValidResult = result != null && result.accessToken != null && result.idToken != null;

    if (isValidResult) {
      auth0AccessToken = result.accessToken;
      await secureStorage.write(
        key: ID_TOKEN_KEY,
        value: result.idToken,
      );
      idToken = parseIdToken(result.idToken!);
      profile = await getUserDetails(result.accessToken!);

      if (result.refreshToken != null) {
        await secureStorage.write(
          key: REFRESH_TOKEN_KEY,
          value: result.refreshToken,
        );
      }

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      var appAuth = const FlutterAppAuth();
      final idTokenStr = await secureStorage.read(key: ID_TOKEN_KEY);

      await appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idTokenStr,
          issuer: AUTH0_ISSUER,
          postLogoutRedirectUrl: AUTH0_LOGOUT_URL,
        ),
      );

      await secureStorage.deleteAll();
      profile = null;
      idToken = null;
      auth0AccessToken = null;
    } catch (e) {
      print('log: Logout error: $e');
    }

    // await secureStorage.delete(key: REFRESH_TOKEN_KEY);
  }
}
