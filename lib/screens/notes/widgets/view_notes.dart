import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewNote extends StatefulWidget {
  final DocumentReference ref;
  final Map data;
  ViewNote(this.ref, this.data);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  void update(
      String title, String description, DocumentReference reference) async {
    // save to db
    // CollectionReference ref = FirebaseFirestore.instance
    //     .collection('NotesCollection')
    //     .doc(FirebaseAuth.instance.currentUser?.uid)
    //     .collection('notes');

    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };
    print('updated');
    print(FirebaseAuth.instance.currentUser?.uid);
    reference.update(data);

    //

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime mydateTime = widget.data['created'].toDate();
    String formattedTime =
        'Created on ' + DateFormat.yMMMd().add_jm().format(mydateTime);
    String initialTitle = widget.data['title'];
    String initialDescription = widget.data['description'];
    TextEditingController titleController =
        TextEditingController(text: initialTitle);
    TextEditingController descriptionController =
        TextEditingController(text: initialDescription);
    // String createdAt = widget.data['created'];
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
              Text(formattedTime),
              IconButton(
                icon: Icon(Icons.save_alt_outlined),
                onPressed: () {
                  update(titleController.text, descriptionController.text,
                      widget.ref);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.share_outlined)),
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
                  child: Container(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Title'),
                          style: const TextStyle(fontSize: 22),
                          maxLines: 2,
                        ),
                        TextFormField(
                          // initialValue: initialDescription,
                          controller: descriptionController,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Description'),
                          style: const TextStyle(fontSize: 16),
                          maxLines: 35,
                          textInputAction: TextInputAction.newline,
                        )
                      ],
                    ),
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
