import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Sign in google
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String uid;
String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  try {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.uid != null);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    uid = user.uid;
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    
    sharedPreferences.setString("google_uid", uid);
    sharedPreferences.setString("google_name", name);
    sharedPreferences.setString("google_email", email);
    sharedPreferences.setString("google_photo", imageUrl);
    
    return 'success';
  } on PlatformException catch (e) {
    return 'error';
  }
}

void signOutGoogle() async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove("google_uid");
  sharedPreferences.remove("google_name");
  sharedPreferences.remove("google_email");
  sharedPreferences.remove("google_photo");

  await googleSignIn.signOut();
  print("User Sign Out");
}