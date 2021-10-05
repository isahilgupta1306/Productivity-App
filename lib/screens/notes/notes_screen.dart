import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/helpers/intent_share_module/share_services.dart';
import 'package:productivity_app/screens/notes/widgets/side_drawer.dart';
import 'package:productivity_app/screens/notes/widgets/view_notes.dart';
import 'package:productivity_app/screens/url_collection.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String sharedUrl = "";

  CollectionReference ref = FirebaseFirestore.instance
      .collection('NotesCollection')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  String? userName;
  AuthenticationService authServObj =
      AuthenticationService(FirebaseAuth.instance);

  getName() async {
    print('yes');
    userName = await authServObj.getUserDetails();

    print(userName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    String? displayName;

    var deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        key: _drawerKey,
        drawer: SideDrawer('Hey there !'),
        backgroundColor: bgColorDark,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 18, bottom: 20),
                  child: Container(
                    width: deviceSize.width,
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(color: white.withOpacity(0.22)),
                        color: cardColorbgColorDark,
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 3),
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              _drawerKey.currentState?.openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu,
                            ),
                            color: white.withOpacity(0.7),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          //  fontSize: 15, color: white.withOpacity(0.7))
                          SizedBox(
                            width: deviceSize.width * 0.5,
                            child: TextFormField(
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Search your notes',
                                  hintStyle: TextStyle(
                                    color: white.withOpacity(0.7),
                                  )),
                            ),
                          ),
                          Icon(
                            Icons.person_outline,
                            color: Theme.of(context).iconTheme.color,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 14, right: 14),
                  height: deviceSize.height * 0.78,
                  child: FutureBuilder<QuerySnapshot>(
                    future: ref.get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: StaggeredGridView.countBuilder(
                              crossAxisCount: 2, //for column
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                var notesData =
                                    snapshot.data?.docs[index].data() as Map;
                                String? title = notesData["title"].toString();
                                String? description =
                                    notesData["description"].toString();
                                return InkWell(
                                  splashColor: white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => ViewNote(
                                                snapshot.data!.docs[index]
                                                    .reference,
                                                notesData)))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: cardColorbgColorDark,
                                        border: Border.all(
                                            color: white.withOpacity(0.22)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: white.withOpacity(0.9),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          description,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          maxLines: 8,
                                          style: TextStyle(
                                              fontSize: 13,
                                              height: 1.5,
                                              color: white.withOpacity(0.7),
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              staggeredTileBuilder: (index) {
                                return const StaggeredTile.fit(1);
                                // return StaggeredTile.count(
                                //     1, index.isEven ? 1.4 : 1.0);
                              }),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                //end of grid
              ],
            ),
          ),
        ),
        // bottomSheet: getFooter(),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
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
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}



// Widget getBody(BuildContext ctx) {
//   var deviceSize = MediaQuery.of(ctx).size;
//   return ListVieW();
// }
