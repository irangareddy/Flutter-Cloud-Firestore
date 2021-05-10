import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cloud_firestore/services/authentication_service.dart';
import 'package:flutter_cloud_firestore/ui/add_movie.dart';
import 'package:flutter_cloud_firestore/utility/helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class FaveFlicks extends StatefulWidget {
  @override
  _FaveFlicksState createState() => _FaveFlicksState();
}

class _FaveFlicksState extends State<FaveFlicks> {
  // 1
  final firebase = FirebaseFirestore.instance;
  CollectionReference collection;
  User user;
  String collectionId;

  // 2
  @override
  void initState() {
    setState(() {
      user = context.read<AuthenticationService>().getUser();
      collectionId = user.email;
      collection = firebase.collection(collectionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6.0,
        centerTitle: true,
        title: Text('FaveFlicks'),
      ),
      body: // 3
          StreamBuilder<QuerySnapshot>(
              stream: firebase.collection('movies').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // 4
                  final List<DocumentSnapshot> documents = snapshot.data.docs;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                        children: documents
                            .map(
                              (doc) => movieTile(doc),
                            )
                            .toList()),
                  );
                } else if (snapshot.hasError) {
                  // 5
                  return Text("🐞: " + snapshot.error.toString());
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => AddMovie(),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

//TODO 7: Replace movieTile for Slidable List

  Padding movieTile(DocumentSnapshot doc) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Slidable(
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Update',
              color: Color(0xFF5DA271),
              icon: Icons.edit,
              onTap: () {
                //TODO 8: Navigate to Add Movie Screen With Edit Feature
                showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddMovie(
                    id: 'movies',
                    isEditMode: true,
                    docId: doc.id,
                  ),
                );
              }),
          IconSlideAction(
            caption: 'Delete',
            color: Color(0xFFE84855),
            icon: Icons.delete,
            onTap: () {
              //TODO 10: Method Call to Delete Document
              deleteDocument(id: doc.id.toString());
 showSnackbar(context, doc['title'].toString()+'Movie Deleted');
            },
          ),
        ],
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: ListTile(
            title: Text(
              doc['title'].toString(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(doc['genre'].toString()),
            trailing: Text(getReleaseDate(doc['release_date'])),
            onTap: () {
              // Show Movie Details If needed
            },
          ),
        ),
      ),
    );
  }

//TODO 9: Add Delete Document Method
  Future<void> deleteDocument({String id}) {
    return collection
        .doc(id)
        .delete()
        .then((value) => print("Movie Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
