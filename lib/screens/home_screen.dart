import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:productivity_app/screens/notes/add_note.dart';
import 'package:productivity_app/screens/notes/notes_screen.dart';
import 'package:productivity_app/screens/word_store.dart';
import 'package:productivity_app/screens/url_collection.dart';

class HomeScreen extends StatefulWidget {
  int ind;
  HomeScreen(this.ind, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.ind;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      const WordsStore(),
      const NotesScreen(),
      URLCollection(),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddNote()))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
      // bottomNavigationBar: BottomAppBar(
      //   //bottom navigation bar on scaffold
      //
      //   shape: CircularNotchedRectangle(), //shape of notch
      //   notchMargin:
      //       5, //notche margin between floating button and bottom appbar
      //   child: Row(
      //     //children inside bottom appbar
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(
      //           Icons.menu,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.search,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: Icon(
      //           Icons.print,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
      body: _children[_currentIndex],
    );
  }
}
