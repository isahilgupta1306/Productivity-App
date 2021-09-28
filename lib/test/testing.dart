import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/models/notes_data_model.dart';
import 'package:firestore_search/firestore_search.dart';

class WidgetTesting extends StatefulWidget {
  const WidgetTesting({Key? key}) : super(key: key);

  @override
  _WidgetTestingState createState() => _WidgetTestingState();
}

class _WidgetTestingState extends State<WidgetTesting> {
  NotesDataModel model = NotesDataModel();

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'notes',
      searchBy: 'name',
      dataListFromSnapshot: model.dataListFromSnapshot(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<NotesDataModel> dataList = snapshot.data;

          return ListView.builder(
              itemCount: dataList?.length ?? 0,
              itemBuilder: (context, index) {
                final NotesDataModel data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${data?.title ?? ''}'),
                    Text('${data?.description ?? ''}')
                  ],
                );
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
