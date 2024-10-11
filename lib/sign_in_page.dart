import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'firebase_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthService authService = AuthService();

  bool isAlreayLogin = false;
  String? accessToken;

  void _login() async {
    await authService.signInWithOIDC();
    checkLogin();
  }

  void _logout() async {
    await authService.logout();
    accessToken = null;
    isAlreayLogin = false;
    setState(() {});
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkLogin();
    if (FirebaseService.auth.currentUser != null) {
      FirebaseService.instance.listenToTokens();
    }
  }

  Future checkLogin() async {
    String? token = await authService.getAccessToken();
    print("log: ${auth.currentUser?.email}");
    print("log: ${auth.currentUser?.displayName}");
    if (auth.currentUser == null && token != null) {
      _logout();
    } else if (token != null) {
      accessToken = token;
      isAlreayLogin = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter OIDC SSO APP 1'),
      ),
      body: Center(
          child: isAlreayLogin
              ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: _logout,
                      child: Text('logout'),
                    ),
                    Text("Access Token: ${accessToken}"),
                    Text("User Email: ${auth.currentUser?.email}"),
                    Text("User Email: ${auth.currentUser?.displayName}"),
                  ],
                )
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Sign in with OIDC'),
                    ),
                    Text("Access Token: ${accessToken}"),
                    Text("User Email: ${auth.currentUser?.email}"),
                    Text("User Email: ${auth.currentUser?.displayName}"),
                  ],
                )),
    );
  }
}
