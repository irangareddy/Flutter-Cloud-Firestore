import 'package:flutter/material.dart';
import 'package:flutter_cloud_firestore/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

// 1
  User user;

  @override
  void initState() {
    setState(() {
      // 2
      user = context.read<AuthenticationService>().getUser();
    });
    super.initState();
  }

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


