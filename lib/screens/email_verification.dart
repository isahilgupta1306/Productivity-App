import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/screens/login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _auth = FirebaseAuth.instance;
  User? user;
  late Timer timer;

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    user = _auth.currentUser;
    if (user != null) {
      user?.sendEmailVerification();
    }

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    Timer delayTimer;
    try {
      user = _auth.currentUser;
      if (user != null) {
        await user?.reload();
        if (user!.emailVerified) {
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your Email is Verified")));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail;
    if (user != null) {
      userEmail = user?.email;
    } else {
      userEmail = 'Email Already in Use';
    }
    return Scaffold(
      body: Center(
        child: Text('Email sent to : $userEmail'),
      ),
    );
  }
}
