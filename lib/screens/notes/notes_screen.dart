import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:productivity_app/helpers/custom_colors.dart';
import 'package:productivity_app/screens/notes/widgets/side_drawer.dart';
import 'package:productivity_app/screens/notes/widgets/view_notes.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  CollectionReference ref = FirebaseFirestore.instance
      .collection('NotesCollection')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      drawer: SideDrawer(),
      backgroundColor: bgColorDark,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 18, bottom: 20),
              child: Container(
                width: deviceSize.width,
                height: 45,
                decoration: BoxDecoration(
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
                        icon: Icon(Icons.menu),
                        color: white.withOpacity(0.7),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      //  fontSize: 15, color: white.withOpacity(0.7))
                      SizedBox(
                        width: deviceSize.width * 0.5,
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Search your notes'),
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
              margin: EdgeInsets.only(left: 14, right: 14),
              height: deviceSize.height * 0.78,
              child: FutureBuilder<QuerySnapshot>(
                future: ref.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ViewNote(
                                      snapshot.data!.docs[index].reference,
                                      notesData)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: cardColorbgColorDark,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(
                                children: [
                                  Text(
                                    title,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Description",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    maxLines: 12,
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
                          return StaggeredTile.count(
                              1, index.isEven ? 1.2 : 1.8);
                        });
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),

            //end of grid
          ],
        ),
      ),
      // bottomSheet: getFooter(),
    );
  }
}



// Widget getBody(BuildContext ctx) {
//   var deviceSize = MediaQuery.of(ctx).size;
//   return ListVieW();
// }
