//used in Searrch Implementations

class NotesDataModel {
  final String? title;
  final String? description;
  final DateTime? created;
  NotesDataModel({this.title, this.description, this.created});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

}
