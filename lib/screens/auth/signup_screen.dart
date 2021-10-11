import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/helpers/fade_route.dart';
import 'package:productivity_app/screens/auth/email_verification.dart';
import 'package:productivity_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: themeProvider.isLightTheme ? dimWhite : bgColorDark,
      body: SingleChildScrollView(
        child: Container(
          // decoration:
          //     const BoxDecoration(color: Color.fromRGBO(244, 244, 244, 100)),
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 65.0,
              // ),
              // SvgPicture.asset(
              //   'assets/signup.svg',
              //   height: deviceSize.height * 0.17,
              // ),
              const SizedBox(
                height: 80,
              ),
              Text(
                'Be Creative',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: themeProvider.isLightTheme
                        ? royalBlack
                        : white.withOpacity(0.7)),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 18,
                  color: themeProvider.isLightTheme
                      ? const Color.fromRGBO(89, 89, 89, 1.0)
                      : white.withOpacity(0.7),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailAddressConttroller = TextEditingController();
  final _userNameController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _signup() async {
    String? status = await context.read<AuthenticationService>().signUp(
        email: _emailAddressConttroller.text.trim(),
        password: _passwordController.text.trim());
    await context
        .read<AuthenticationService>()
        .userDetails(_userNameController.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(status!)));
    print(status);
    Navigator.of(context).pushReplacement(
      FadeRoute(page: const EmailVerificationScreen()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error Occurred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final deviceSize = MediaQuery.of(context).size;
    final labelStyle = TextStyle(
        color: themeProvider.isLightTheme
            ? Colors.grey[600]
            : white.withOpacity(0.7));
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.87,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: themeProvider.isLightTheme
                            ? Colors.white
                            : cardColorbgColorDark,
                        filled: true,
                        prefixIcon: Icon(Icons.person_outline,
                            color: themeProvider.isLightTheme
                                ? Colors.grey[600]
                                : white.withOpacity(0.7)),
                        hintText: 'Your Name',
                        hintStyle: labelStyle,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Your Name";
                        }
                      },
                      controller: _userNameController,
                      onSaved: (value) {
                        //function
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.87,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: themeProvider.isLightTheme
                            ? Colors.white
                            : cardColorbgColorDark,
                        filled: true,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: themeProvider.isLightTheme
                                ? Colors.grey[600]
                                : white.withOpacity(0.7)),
                        hintText: 'E-Mail',
                        hintStyle: labelStyle,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || !value.contains('@')) {
                          return "Enter Valid Email Address";
                        }
                      },
                      controller: _emailAddressConttroller,
                      onSaved: (value) {
                        //function
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.87,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: themeProvider.isLightTheme
                            ? Colors.white
                            : cardColorbgColorDark,
                        filled: true,
                        prefixIcon: Icon(Icons.lock_outline,
                            color: themeProvider.isLightTheme
                                ? Colors.grey[600]
                                : white.withOpacity(0.7)),
                        hintText: 'Password',
                        hintStyle: labelStyle,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: _obscureText
                              ? Icon(Icons.visibility,
                                  color: themeProvider.isLightTheme
                                      ? Colors.grey[600]
                                      : white.withOpacity(0.7))
                              : Icon(Icons.visibility_off,
                                  color: themeProvider.isLightTheme
                                      ? Colors.grey[600]
                                      : white.withOpacity(0.7)),
                          onPressed: _toggle,
                        ),
                      ),
                      obscureText: _obscureText,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        //
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.87,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: themeProvider.isLightTheme
                            ? Colors.white
                            : cardColorbgColorDark,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: themeProvider.isLightTheme
                              ? Colors.grey[600]
                              : white.withOpacity(0.7),
                        ),
                        hintText: 'Confirm Password',
                        hintStyle: labelStyle,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(28),
                          ),
                          borderSide: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: _obscureText
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: _toggle,
                        ),
                      ),
                      obscureText: _obscureText,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.length < 5) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        //
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: deviceSize.width * 0.38,
              height: deviceSize.height * 0.064,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));
                  }
                  _signup();
                },
                child: const Text('SignUp'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: const LoginScreen(),
                  ),
                );
              },
              child: const Text("Already have an Account ? Click here"),
            ),
          ],
        ),
      ),
    );
  }
}
