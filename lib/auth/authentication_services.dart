import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Account Created';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> userDetails(String displayName) async {
    String? uid = _firebaseAuth.currentUser?.uid;
    CollectionReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('UserCred');

    String? email = _firebaseAuth.currentUser?.email;
    if (uid != null) {
      var obj = users.add({
        'displayName': displayName,
        'uid': uid,
        'emailAddress': email,
        'provider': 'byEmail'
      });
    }
  }

  Future<String?> getUserDetails() async {
    String? uid = _firebaseAuth.currentUser?.uid;
    var userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('UserCred')
        .get();

    String? name = userData.docs[0]['displayName'];
    return name;
    // print(name);
    print(userData.docs[0]['displayName']);
  }
}
