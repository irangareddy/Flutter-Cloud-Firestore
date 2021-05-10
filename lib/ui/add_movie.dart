import 'package:flutter/material.dart';
import 'package:flutter_cloud_firestore/utility/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMovie extends StatefulWidget {
  // 1
  final String id;
  final bool isEditMode;
  final String docId;

  AddMovie({this.id, this.isEditMode, this.docId});
  @override
  _Addcollectiontate createState() => _Addcollectiontate();
}

class _Addcollectiontate extends State<AddMovie> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _genreController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool get _isEditMode => widget.isEditMode;
  String get _id => widget.id;
  String get _docId => widget.docId;

  CollectionReference collection;
  DocumentSnapshot document;

  @override
  void initState() {
    collection = FirebaseFirestore.instance.collection(_id);
    checkEdit();
    super.initState();
  }

  // 2
  void checkEdit() async {
    if (_isEditMode) {
      document = await collection.doc(_docId).get();
      Map<String, dynamic> movie =
          new Map<String, dynamic>.from(document.data());
      _titleController.text = movie['title'];
      _genreController.text = movie['genre'];
      setState(() {
        _selectedDate = getDateTime(movie['release_date']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        centerTitle: true,
        title: Text(
          "New Flick",
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () {
                if (_titleController.text != null &&
                    _genreController.text != null) {
                  // 3
             if (_isEditMode) {
               updateDocument();
             } else {
                addDocument();
             }
          } else {
          showSnackbar(context, "Fill the Details Properly");
        }
      Navigator.of(context).pop();
              },
              // 4
         child: Text(
  _isEditMode ? "Update" : "Add",
  style: TextStyle(fontSize: 18, color: Colors.indigoAccent),
              ))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GestureDetector(
          onTap: _dismissKeyboard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
 baseTitle('Title'),
 baseTextField(
     hintText: 'Add Movie Title', controller: _titleController),
 baseTitle('Genre'),
 baseTextField(
    hintText: 'Action, Adventure', controller: _genreController),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    baseTitle('Release Date'),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Container(
        decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: TextButton(
                          child: Padding(
            padding:
                    const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                                "${_selectedDate.toLocal()}".split(' ')[0],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo)),
                          ),
        onPressed: () => _selectDate(context), // Refer step
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateDocument() {
    return collection
        .doc(_docId) // Reference Doc Id to Update
        .update({
          'title': _titleController.text,
          'genre': _genreController.text,
          'release_date': _selectedDate,
          'created': DateTime.now(),
        })
    .then((value) => print("Movie Updated"))
    .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addDocument() {
    // Call the user's CollectionReference to add a new Movie
    return collection
        .add({
          'title': _titleController.text,
          'genre': _genreController.text,
          'release_date': _selectedDate,
          'created': DateTime.now(),
        })
  .then((value) => print("Movie Added"))
   .catchError((error) => print("Failed to add Movie: $error"));
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigoAccent,
            accentColor: Colors.indigoAccent,
            colorScheme: ColorScheme.light(primary: Colors.indigoAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Padding baseTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 8, bottom: 4),
      child: Text(
        '$title',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Padding baseTextField({String hintText, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextField(
          style: TextStyle(fontSize: 16),
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                width: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            labelStyle: TextStyle(fontSize: 16),
            hintStyle: TextStyle(fontSize: 16),
            hintText: '$hintText',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
          ),
          keyboardType: hintText == "Add Release Date"
              ? TextInputType.datetime
              : TextInputType.text,
        ),
      ),
    );
  }
}
