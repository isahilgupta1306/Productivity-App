import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    DateTime mydateTime = widget.data['created'].toDate();
    String formattedTime = DateFormat.yMMMd().add_jm().format(mydateTime);
    String initialTitle = widget.data['title'];
    String initialDescription = widget.data['description'];
    TextEditingController titleController =
        TextEditingController(text: initialTitle);
    TextEditingController descriptionController =
        TextEditingController(text: initialDescription);
    // String createdAt = widget.data['created'];
    print('title' + initialTitle);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Text(formattedTime),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new))
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
                      decoration: InputDecoration.collapsed(hintText: 'Title'),
                      style: TextStyle(fontSize: 22),
                      maxLines: 2,
                    ),
                    TextFormField(
                      // initialValue: initialDescription,
                      controller: descriptionController,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Description'),
                      style: TextStyle(fontSize: 16),
                      maxLines: 35,
                      textInputAction: TextInputAction.newline,
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
