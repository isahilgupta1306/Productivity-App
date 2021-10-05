import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _add(String title, String description) async {
    //dB reference
    CollectionReference ref = FirebaseFirestore.instance
        .collection('NotesCollection')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');
    var data = {
      'title': title,
      'description': description,
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
      child: WillPopScope(
        onWillPop: () => showExitPopup(
            context, titleController.text, descriptionController.text),
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
                  onPressed: () => modalBottomSheet(
                      titleController.text, descriptionController.text),
                ),
                const Text('Save your Note'),
                IconButton(
                  icon: const Icon(Icons.save_alt_outlined),
                  onPressed: () =>
                      _add(titleController.text, descriptionController.text),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => _addText(
                      titleController.text, descriptionController.text),
                  icon: const Icon(Icons.share_outlined)),
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
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Title'),
                          style: const TextStyle(fontSize: 22),
                          maxLines: 2,
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Description'),
                          style: const TextStyle(fontSize: 16),
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
      ),
    );
  }

  Future<bool> showExitPopup(context, String title, String description) async {
    return await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Do you want to save your work ?"),
              content: const Text("Tap Yes to Save your Notes"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    if (title == null && description == null) {
                      Navigator.pop(context);
                      print('no new updates');
                    } else {
                      _add(title, description);
                      Navigator.pop(context);
                    }
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
                    if (title == null || description == null) {
                      return;
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void modalBottomSheet(String? title, String? description) {
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
                  try {
                    String? message = null;
                    if (title == null) {
                      message = description;
                      Share.share(message!, subject: description);
                      return;
                    } else if (description == null) {
                      message = title;
                      Share.share(message, subject: description);
                      return;
                    } else {
                      message = title + "\n" + description;
                      final RenderObject? box = context.findRenderObject();
                      {
                        Share.share(message);
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
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
              title: const Text("Are you sure you want to delete ?"),
              content: const Text('Tap Yes to delete permanently'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    // delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ));
  }

  void _addText(String title, String description) {
    FlutterClipboard.copy(title + '\n' + description)
        .then((value) => print('copied'));
  }
}
