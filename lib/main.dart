import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gitpod_flutter_quickstart/wrapper.dart';
import 'firebase_options.dart';

/* void main() {
  runApp(const MyApp());
} */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( const MaterialApp(home: Wrapper()));
}