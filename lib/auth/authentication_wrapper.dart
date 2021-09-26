import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/signup_screen.dart';
import 'package:provider/provider.dart';

class AuthenticcationWrapper extends StatelessWidget {
  const AuthenticcationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    } else {
      return const SignupScreen();
    }
  }
}
