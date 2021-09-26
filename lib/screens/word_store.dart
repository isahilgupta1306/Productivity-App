import 'package:flutter/material.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:provider/provider.dart';

class WordsStore extends StatefulWidget {
  const WordsStore({Key? key}) : super(key: key);

  @override
  _WordsStoreState createState() => _WordsStoreState();
}

class _WordsStoreState extends State<WordsStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text('WordStore'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: const Text('Signout'),
          )
        ],
      ),
    );
  }
}
