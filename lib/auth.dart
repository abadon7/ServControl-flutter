import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Auth extends StatelessWidget {
  Auth({Key? key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: googleSignIn,
          child: const Text('Login with Googles'),
        ),
      ),
    );
  }

  //Sign in with google auth
  Future googleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = await _auth.signInWithCredential(credential);
    //var user = await _auth.signInWithPopup(auth.GoogleAuthProvider());
    return user;
  }
}
