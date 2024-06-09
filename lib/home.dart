import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);
  //const HomePage(User? user, {super.key});
  final User? userInfo = FirebaseAuth.instance.currentUser;

  Future<void> readData() async {
    print("READING DATABASE");
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('users');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      print(dataSnapshot.value);
      Map<String, dynamic> data = jsonDecode(jsonEncode(dataSnapshot.value));
      //Map<String, dynamic> values = dataSnapshot.value as Map<String, dynamic>;
      data.forEach((key, values) {
        print('Key: $key');
        print('Name: ${values['name']}');
        print('Email: ${values['email']}');
        print('Age: ${values['age']}');
      });
    });
  }

  @override
  
  Widget build(BuildContext context) {
    readData();
    print('USER = $userInfo');
    return Scaffold(
      body: Center(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:580700638.
        child: Text('Home Page of ServControl ${userInfo?.displayName}'),
      ),
    );
  }
}