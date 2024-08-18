import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBars extends AppBar {
  // Suggested code may be subject to a license. Learn more: ~LicenseLog:1784550236.
  AppBars(User? userInfo, {super.key})
      : super(
          title: const Center(child: Text("ServControl")),
          actions: <Widget>[
// Suggested code may be subject to a license. Learn more: ~LicenseLog:976259272.
            CircleAvatar(
              backgroundImage: NetworkImage(userInfo!.photoURL.toString()),
            ),
            /* IconButton(
            //icon: const Icon(Icons.comment),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1098745684.
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ), //IconButton */
          ], //<Widget>[]
          backgroundColor: Colors.white,
          elevation: 50.0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu Icon',
            onPressed: () {},
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        );
}

class DataTableExample extends StatelessWidget {
  final Map<String, dynamic> srvdata;
  const DataTableExample({super.key, required this.srvdata});

  @override
  Widget build(BuildContext context) {
    print('DATABALE');
    for (var value in srvdata.values) {
      print(value['est']);
    }

    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Hours',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Studies',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: srvdata.values
          .map((value) => DataRow(cells: [
                DataCell(Text(value['date'])),
                DataCell(Text(value['horas'])),
                DataCell(Text(value['est'])),
              ]))
          .toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  //const HomePage(User? user, {super.key});
  final User? userInfo = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> currentData = {};
  //final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> readData() async {
    print("READING DATABASE");
    final now = DateTime.now();
    print(now.year);
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('control/${userInfo!.displayName?.split(" ")[0]}/${now.year}/5');

    databaseReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      print(dataSnapshot.value);
      Map<String, dynamic> data = jsonDecode(jsonEncode(dataSnapshot.value));
      currentData = data;
      //Map<String, dynamic> values = dataSnapshot.value as Map<String, dynamic>;
      for (var value in currentData.values) {
        //print('Key: $key');
        print(value['date']);
        /* print('Name: ${values['name']}');
        print('Email: ${values['email']}');
        print('Age: ${values['age']}'); */
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readData();
    print('USER = $userInfo');
    return Scaffold(
        appBar: AppBars(userInfo),
        body: Center(
          child: DataTableExample(srvdata: currentData),
        ));
    /* body: Center(
        child: Text(
          'Home Page of ServControl ${userInfo!.displayName?.split(" ")[0]}',
          style: const TextStyle(fontSize: 24),
        ), //Text 
      ), //Center
      //Scaffold
      // debugShowCheckedModeBanner: false, //Removing Debug Banner
    );*/
  }

  center(Text text) {}
}
