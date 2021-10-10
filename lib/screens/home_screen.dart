import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/notes/add_note.dart';
import 'package:productivity_app/screens/notes/notes_screen.dart';
import 'package:productivity_app/screens/word_store.dart';
import 'package:productivity_app/screens/URL%20Module/url_collection.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

class HomeScreen extends StatefulWidget {
  int ind;
  HomeScreen(this.ind, {Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

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
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _urlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      const WordsStore(),
      const NotesScreen(),
      URLCollection(),
    ];
    // Now we have access to the theme properties
    final themeProvider = Provider.of<ThemeProvider>(context);
    var deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        extendBody: true,
        floatingActionButton: SpeedDial(
            icon: CupertinoIcons.add,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(
                color: themeProvider.isLightTheme ? white : black),
            children: [
              SpeedDialChild(
                labelStyle: const TextStyle(color: black),
                child: const Icon(Icons.link),
                label: 'Add URL',
                labelBackgroundColor: Colors.white70,
                backgroundColor: Theme.of(context).primaryColor,
                onTap: _modalBottomSheetMenu,
              ),
              SpeedDialChild(
                labelStyle: const TextStyle(color: black),
                child: const Icon(
                  CupertinoIcons.text_alignleft,
                ),
                label: 'Create Notes',
                labelBackgroundColor: Colors.white70,
                backgroundColor: Theme.of(context).primaryColor,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const AddNote()))
                      .then((value) {
                    setState(() {});
                  });
                },
              ),
            ]),
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
      ),
    );
  }

  _modalBottomSheetMenu() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 350.0,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                    color: cardColorbgColorDark,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.title),
                              hintText: 'Title',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(28),
                                ),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(28),
                                ),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            validator: (String? title) {
                              if (title == null || title.isEmpty) {
                                return 'Enter a valid keyword for url';
                              }
                            },
                            controller: _titleController,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: TextFormField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.copy_outlined),
                                onPressed: () {
                                  FlutterClipboard.paste().then((value) {
                                    setState(() {
                                      _urlController =
                                          TextEditingController(text: value);
                                    });
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'Text Copied',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                },
                                splashColor: Colors.white,
                              ),
                              prefixIcon: const Icon(Icons.link),
                              hintText: 'Enter URL',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(28),
                                ),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(28),
                                ),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            validator: (String? url) {
                              if (url == null || !url.contains('http')) {
                                return 'Enter a valid url';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm(context, _titleController.text,
                              _urlController.text);
                          _titleController.clear();
                          _urlController.clear();
                        }
                      },
                      child: const Text('Save URL')),
                ]),
              ),
            );
          });
        });
  }

  _submitForm(BuildContext context, String title, String url) async {
    // More to be added here

    CollectionReference ref = FirebaseFirestore.instance
        .collection('NotesCollection')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('URLCollection');
    var data = {
      'title': title,
      'url': url,
      'created': DateTime.now(),
    };
    ref.add(data);
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: "URL Saved ");
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Are you sure you want to Exit ?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    exit(0);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
