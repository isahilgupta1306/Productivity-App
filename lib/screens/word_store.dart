import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/helpers/dictionary_api.dart';
import 'package:productivity_app/models/disctionary_model.dart';

import 'notes/widgets/side_drawer.dart';

class WordsStore extends StatefulWidget {
  const WordsStore({Key? key}) : super(key: key);

  @override
  _WordsStoreState createState() => _WordsStoreState();
}

class _WordsStoreState extends State<WordsStore> {
  bool descTextShowFlag = false;
  bool isExpanded = false;
  ApiManager apiManager = ApiManager();
  final TextEditingController _controller = TextEditingController();
  late Timer _debounce;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  CollectionReference ref = FirebaseFirestore.instance
      .collection('NotesCollection')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('SavedWords');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: SideDrawer('Hey there !'),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          '< Word Shelf >',
          style:
              GoogleFonts.catamaran(fontSize: 25, fontWeight: FontWeight.w800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: TextFormField(
                        controller: _controller,
                        onFieldSubmitted: (String value) {
                          apiManager.searchByFuture(_controller.text);
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter the word",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 24.0),
                        ),
                        onChanged: (String text) {
                          // if (_debounce?.isActive ?? false) _debounce.cancel();
                          // _debounce =
                          //     Timer(const Duration(milliseconds: 1000), () {
                          //   _searchByFuture();
                          //   setState(() {});
                          // });
                        }),
                  ),
                ),
              ),
              IconButton(
                splashColor: Colors.cyan[900],
                onPressed: () {
                  apiManager.searchByFuture(_controller.text);
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  setState(() {});
                },
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<MeaningModelOwlBot?>(
        future: apiManager.searchByFuture(_controller.text),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.definitions.length,
                itemBuilder: (ctx, index) {
                  String? title = _controller.text;
                  String? subtitle =
                      snapshot.data!.definitions[index].type; //type
                  String? definition =
                      snapshot.data!.definitions[index].definition; //definition
                  String? example = snapshot.data!.definitions[index].example
                      .toString(); //example
                  String? imageUrl = snapshot.data!.definitions[index].imageUrl
                      .toString(); //url

                  return ListBody(
                    children: [
                      Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: const Key('uniqueKI'),
                        background: Container(
                          color: Theme.of(context).primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Save the \nword',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("The word is saved"),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Card(
                            color: Colors.white70,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: !imageUrl.contains('http')
                                      ? CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Icon(
                                            Icons.arrow_right,
                                            color: white.withOpacity(0.5),
                                          ),
                                        )
                                      : CircleAvatar(
                                          maxRadius: 25,
                                          backgroundImage: NetworkImage(
                                            imageUrl,
                                          ),
                                        ),
                                  title: Text(
                                    _controller.text.trim(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    subtitle ??= " ",
                                    style: GoogleFonts.openSans(
                                        color: Colors.cyan[800],
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Definition :",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          definition ??= "Meaning not found",
                                          maxLines: 7,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 16,
                                              color: Colors.grey[1000],
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                        ),
                                        const Text(
                                          "Example :",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          example,
                                          maxLines: 7,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 16,
                                              color: Colors.grey[1000],
                                              fontWeight: FontWeight.w400),
                                        ),
                                        RawChip(
                                          elevation: 1,
                                          shadowColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.6),
                                          avatar: const Icon(
                                            Icons.save_alt_outlined,
                                          ),
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.20),
                                          onPressed: () {
                                            saveWords(title, subtitle,
                                                definition, example, imageUrl);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("The word is Saved"),
                                            ));
                                          },
                                          label: const Text(
                                            'Save Word',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Text('Object is null');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return FutureBuilder<QuerySnapshot>(
            future: ref.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      RawChip(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {},
                        label: Text(
                          '  Saved Words  ',
                          style: GoogleFonts.catamaran(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        shadowColor: Theme.of(context).primaryColor,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          var wordsData =
                              snapshot.data?.docs[index].data() as Map;
                          String? word = wordsData["word"].toString();
                          String? type = wordsData["type"].toString();
                          String? definition =
                              wordsData["definition"].toString();
                          String? example = wordsData["example"].toString();
                          String? image_url = wordsData["image_url"].toString();
                          return ListBody(
                            children: [
                              Dismissible(
                                direction: DismissDirection.startToEnd,
                                key: const Key('uniqueKI'),
                                background: Container(
                                  color: Colors.green,
                                  child: const Text("Add to WordBokk"),
                                ),
                                onDismissed: (direction) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("The word is saved"),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Card(
                                    color: Colors.white70,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: !image_url.contains('http')
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: Icon(
                                                    Icons.arrow_right,
                                                    color:
                                                        white.withOpacity(0.5),
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  maxRadius: 25,
                                                  backgroundImage: NetworkImage(
                                                    image_url,
                                                  ),
                                                ),
                                          title: Text(
                                            word,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          subtitle: Text(
                                            type,
                                            style: GoogleFonts.openSans(
                                                color: Colors.cyan[800],
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Definition :",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  definition,
                                                  maxLines: 7,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      fontSize: 16,
                                                      color: Colors.grey[1000],
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                const Text(
                                                  "Example :",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  example,
                                                  maxLines: 7,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      fontSize: 16,
                                                      color: Colors.grey[1000],
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                RawChip(
                                                  elevation: 1,
                                                  avatar: const Icon(
                                                    Icons.delete_outline,
                                                  ),
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.15),
                                                  onPressed: () {
                                                    _showDialog(
                                                        context,
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                            .reference);
                                                  },
                                                  label: const Text(
                                                    'Remove Word',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              if (!snapshot.hasData) {
                // Fluttertoast.showToast(
                //     msg: "Word Not Found", toastLength: Toast.LENGTH_LONG);
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: Text('Data Loading'));
            },
          );
        },
      ),
    );
  }

  delete() {}

  _showDialog(BuildContext context, DocumentReference ref) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Are you sure you want to delete ?"),
              content: const Text('Tap Yes to delete permanently'),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: () {
                      ref.delete();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("The Word is Removed"),
                      ));
                    }),
                CupertinoDialogAction(
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void saveWords(word, type, definition, example, imageUrl) {
    var wordData = {
      'word': word,
      'type': type,
      'definition': definition,
      'example': example,
      'image_url': imageUrl,
    };
    ref.add(wordData);
  }
}
