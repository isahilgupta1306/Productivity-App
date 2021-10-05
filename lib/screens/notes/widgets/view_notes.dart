import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ViewNote extends StatefulWidget {
  final DocumentReference ref;
  final Map data;
  ViewNote(this.ref, this.data);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  void update(
      String? title, String? description, DocumentReference reference) async {
    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };
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
    return WillPopScope(
      onWillPop: () => showExitPopup(
          context, titleController.text, descriptionController.text),
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    modalBottomSheet(
                        titleController.text, descriptionController.text);
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
                  onPressed: () => _addText(
                      titleController.text, descriptionController.text),
                  icon: const Icon(Icons.copy_outlined)),
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
                            maxLines: 30,
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
      ),
    );
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
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ));
  }

  Future<bool> showExitPopup(
      context, String? title, String? description) async {
    return await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Do you want to save your work ?"),
              content: const Text("Tap Yes to update your Notes"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    if (title == null && description == null) {
                      Navigator.pop(context);
                    } else {
                      update(title, description, widget.ref);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _addText(String title, String description) {
    FlutterClipboard.copy(title + '\n' + description)
        .then((value) => print('copied'));
  }

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }
}
