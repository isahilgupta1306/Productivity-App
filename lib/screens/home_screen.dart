import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/screens/notes/add_note.dart';
import 'package:productivity_app/screens/notes/notes_screen.dart';
import 'package:productivity_app/screens/word_store.dart';
import 'package:productivity_app/screens/url_collection.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    const WordsStore(),
    const NotesScreen(),
    const URLCollection(),
  ];

  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNote()))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.book_circle,
              size: 25,
            ),
            label: 'WordStore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notes_rounded,
            ),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.link_circle),
            label: 'URLs',
          ),
        ],
        onTap: _selectPage,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
      ),
      body: _children[_currentIndex],
    );
  }
}
