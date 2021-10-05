import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';

class AuthenticcationWrapper extends StatelessWidget {
  const AuthenticcationWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return HomeScreen(1);
    } else {
      return const SignupScreen();
    }
  }
}
