import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/screens/email_verification.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 65.0,
              ),
              SvgPicture.asset(
                'assets/signup.svg',
                height: 200,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Be Creative',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(89, 89, 89, 1.0),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SignupForm(),
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
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: deviceSize.width * 0.87,
            child: TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
                labelText: 'E-Mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(28),
                  ),
                  // borderSide: BorderSide(color: Colors.purple),
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
            height: 14,
          ),
          SizedBox(
            width: deviceSize.width * 0.87,
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: 'Password',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(28),
                  ),
                  borderSide: BorderSide(color: Colors.purple),
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
            height: 22,
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
              onPressed: () async {
                String? status = await context
                    .read<AuthenticationService>()
                    .signUp(
                        email: _emailAddressConttroller.text.trim(),
                        password: _passwordController.text.trim());
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(status!)));
                print(status);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EmailVerificationScreen()));
              },
              child: const Text('SignUp'),
            ),
          ),
        ],
      ),
    );
  }
}
