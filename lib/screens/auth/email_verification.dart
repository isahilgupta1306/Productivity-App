import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/auth/login_screen.dart';
import 'package:productivity_app/theme_provider.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    var deviceSize = MediaQuery.of(context).size;
    String? userEmail;
    if (user != null) {
      userEmail = user?.email;
    } else {
      userEmail = 'Email Already in Use';
    }
    return SafeArea(
      child: Scaffold(
          backgroundColor: themeProvider.isLightTheme ? dimWhite : bgColorDark,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                SvgPicture.asset(
                  'assets/emailAuth.svg',
                  height: deviceSize.height * 0.3,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Verify your E-mail',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.catamaran(
                      color: primaryColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Email sent to : \n$userEmail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeProvider.isLightTheme
                          ? Colors.grey[600]
                          : white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )
              ],
            ),
          )),
    );
  }
}
