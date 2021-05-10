import 'package:flutter/material.dart';
import 'package:flutter_cloud_firestore/services/authentication_service.dart';
import 'package:provider/provider.dart';

class FaveFlick extends StatefulWidget {
  const FaveFlick({Key key}) : super(key: key);

  @override
  _FaveFlickState createState() => _FaveFlickState();
}

class _FaveFlickState extends State<FaveFlick> {


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
              fontSize: 20, 
              fontWeight: FontWeight.w500, 
              color: Colors.white
              ),
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
      body: Center(child: Text("Starter Project"),)
    );
  }
}


