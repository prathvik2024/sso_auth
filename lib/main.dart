import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ssoauth/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD4jrhsJACDtSP7SIq_VVf_AWbjMQUdhYI",
            appId: "1:199158867421:android:895a789bb27f3bfdaf8234",
            messagingSenderId: "199158867421",
            projectId: "sso-auth-openid"));
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD4jrhsJACDtSP7SIq_VVf_AWbjMQUdhYI",
            appId: "1:199158867421:ios:8005a44c83d667deaf8234",
            messagingSenderId: "199158867421",
            projectId: "sso-auth-openid"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo SSO APP 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignInPage(),
    );
  }
}
