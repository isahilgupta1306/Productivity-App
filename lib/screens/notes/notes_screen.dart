import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:productivity_app/auth/authentication_services.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/helpers/intent_share_module/share_services.dart';
import 'package:productivity_app/screens/notes/widgets/side_drawer.dart';
import 'package:productivity_app/screens/notes/widgets/view_notes.dart';
import 'package:productivity_app/screens/URL%20Module/url_collection.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';

class NotesScreen extends StatefulWidget {
  NotesScreen({Key? key}) : super(key: key);

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final text_style = TextStyle(
        color: themeProvider.isLightTheme
            ? primaryColorDark
            : white.withOpacity(0.7));
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceSize.height * 0.085,
        title: Text(
          'Notes',
          style: GoogleFonts.catamaran(
              color: primaryColor, fontSize: 35, fontWeight: FontWeight.w800),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                child: Container(
                  width: deviceSize.width * 0.85,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(color: white.withOpacity(0.22)),
                      color:
                          themeProvider.isLightTheme ? dimWhite : bgColorDark,
                      boxShadow: [
                        BoxShadow(
                            color: primaryColorDark.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 4),
                      ],
                      borderRadius: BorderRadius.circular(28)),
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  fontSize: 15, color: white.withOpacity(0.7))
                        SizedBox(
                          width: deviceSize.width * 0.75,
                          child: Center(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      _drawerKey.currentState?.openDrawer();
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      color: themeProvider.isLightTheme
                                          ? primaryColorDark
                                          : white.withOpacity(0.7),
                                    ),
                                    color: white.withOpacity(0.7),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.person_outline,
                                    color: themeProvider.isLightTheme
                                        ? primaryColorDark
                                        : white.withOpacity(0.7),
                                  ),
                                  hintText: 'Search your Notes',
                                  hintStyle: text_style),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      key: _drawerKey,
      drawer: SideDrawer('Hey there !'),
      backgroundColor:
          themeProvider.isLightTheme ? Colors.white54 : bgColorDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 14, right: 14, top: 15),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => ViewNote(
                                              snapshot
                                                  .data!.docs[index].reference,
                                              notesData)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: themeProvider.isLightTheme
                                          ? primaryColorDark
                                          : bgColorDark, //cardColorbgColorDark,
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
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}



  



// Widget getBody(BuildContext ctx) {
//   var deviceSize = MediaQuery.of(ctx).size;
//   return ListVieW();
// }
