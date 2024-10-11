import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._();

  FirebaseService._();

  static FirebaseService get instance => _instance;

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> storeTokens(String idToken, String accessToken, String appBundleId) async {
    User? user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    String uid = user.uid;

    // Save tokens under the user's app ID
    await firestore.collection('users').doc(uid).collection('apps').doc(appBundleId).set({
      'access_token': accessToken,
      'id_token': idToken,
    });
  }

  void listenToTokens() {
    User? user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    String uid = user.uid;
    firestore.collection('users').doc(uid).collection("apps").snapshots().listen((event) {
      for (var element in event.docChanges) {
        log("log listen: ${element.doc.data()}");
      }
    });
  }
}
