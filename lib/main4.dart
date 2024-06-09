import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

class User {
  final String? name;
  final String? email;

  const User(this.name, this.email);
}

Future<void> main() async {
  // Ensure that Firebase is initialized before running the app
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential? user = await signInWithGoogle();
      if (user.user != null) {
        final User currentUser = User(user.user!.displayName, user.user!.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in with Google: ${user.user!.displayName}'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DataScreen(user: currentUser),
          ),
        );
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Google. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signInWithGoogle(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}

// Function to sign in with Google
/* Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final OAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);
      return userCredential.user;
    } else {
      print('Google Sign-In canceled');
      return null;
    }
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
} */

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
    rethrow;
  }

  // Once signed in, return the UserCredential
}

class DataScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DataScreen({super.key, required this.user});

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

  // Declare a field that holds the Todo.
  final User user;

  @override
  Widget build(BuildContext context) {

    Future<void> signOut() async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    // Navigate to the sign-in page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}
    // Use the Todo to create the UI.
    readData();
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(user.email!),
      ),
    );
  }
}

