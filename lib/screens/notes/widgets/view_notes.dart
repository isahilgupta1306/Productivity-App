import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };
    print('updated');
    print(FirebaseAuth.instance.currentUser?.uid);
    await reference.update(data);
  }

  @override
  void initState() {
    super.initState();
    // _showPersistantBottomSheetCallBack = _showBottomSheet;
  }

  @override
  Widget build(BuildContext context) {
    DateTime mydateTime = widget.data['created'].toDate();
    String formattedTime = 'Edited ' + DateFormat.MMMd().format(mydateTime);
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
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {
                  modalBottomSheet();
                },
              ),
              Text(formattedTime),
              IconButton(
                icon: const Icon(Icons.save_alt_outlined),
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

  void modalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(CupertinoIcons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.delete_simple),
                title: const Text('Delete Note'),
                onTap: () {
                  _showDialog(context);
                },
              ),
            ],
          );
        });
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Are you sure you want to delete ?"),
              content: const Text('Tap Yes to delete permanently'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _showExitDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Do you want to save your notes ?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Yes"),
                  onPressed: () {
                    delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }
}
