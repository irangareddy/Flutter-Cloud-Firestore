import 'package:flutter/material.dart';
import 'package:flutter_cloud_firestore/services/authentication_service.dart';
import 'package:flutter_cloud_firestore/ui/add_movie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class FaveFlicks extends StatefulWidget {
  const FaveFlicks({Key key}) : super(key: key);

  @override
  _FaveFlicksState createState() => _FaveFlicksState();
}

class _FaveFlicksState extends State<FaveFlicks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'FaveFlicks',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // 3
                context.read<AuthenticationService>().signOut();
              })
        ],
      ),
      body: Center(
        child: Text("Starter Project"),
      ),

      //TODO 1: Add Floating Action Button
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
}
