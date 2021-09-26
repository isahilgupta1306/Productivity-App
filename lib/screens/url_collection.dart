import 'package:flutter/material.dart';

class URLCollection extends StatefulWidget {
  const URLCollection({Key? key}) : super(key: key);

  @override
  _URLCollectionState createState() => _URLCollectionState();
}

class _URLCollectionState extends State<URLCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('URL'),
      ),
    );
  }
}
