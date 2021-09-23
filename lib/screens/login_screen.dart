import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/screens/signup_screen.dart';
import 'package:provider/src/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                'assets/login.svg',
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
                'Login to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(89, 89, 89, 1.0),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
      decoration: BoxDecoration(color: Colors.white38),
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
              autofillHints: const [AutofillHints.email],
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
              onPressed: () {
                context.read<AuthenticationService>().login(
                    email: _emailAddressConttroller.text.trim(),
                    password: _passwordController.text.trim());
              },
              child: const Text('Login'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignupScreen()));
            },
            child: const Text("Create an Account"),
          ),
        ],
      ),
    );
  }
}