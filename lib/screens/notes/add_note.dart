import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
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
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              Text('Sample'),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
        appBar: AppBar(
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
                      decoration: InputDecoration.collapsed(hintText: 'Title'),
                      style: TextStyle(fontSize: 22),
                      maxLines: 2,
                    ),
                    TextFormField(
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
  }
}
