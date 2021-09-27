import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _add() async {
    // save to db
    CollectionReference ref = FirebaseFirestore.instance
        .collection('NotesCollection')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    var data = {
      'title': titleController.text,
      'description': descriptionController.text,
      'created': DateTime.now(),
    };
    print('uid ');
    print(FirebaseAuth.instance.currentUser?.uid);
    ref.add(data);

    //

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert_outlined),
                onPressed: () {},
              ),
              Text('Save your Note'),
              IconButton(
                icon: Icon(Icons.save_alt_outlined),
                onPressed: _add,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
          ],
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Title'),
                        style: TextStyle(fontSize: 22),
                        maxLines: 2,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Description'),
                        style: TextStyle(fontSize: 16),
                        maxLines: 35,
                        textInputAction: TextInputAction.newline,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
