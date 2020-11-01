import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants.dart' as Constants;
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  try {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }
  } on PlatformException catch (e) {
    print("PLATFORM ERROR: " + e.toString());
  } catch (error) {
    print("OTHER ERROR: " + error.toString());
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}

Future<String> signUp(String user, String pass) async {
  try {
    await Firebase.initializeApp();
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user, password: pass);
    print("SIGN IN UID: " + userCredential.user.uid);
    print("Data Returned " + userCredential.user.toString());
    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } on PlatformException catch (e) {
    print("PLATFORM ERROR: " + e.toString());
  } catch (error) {
    print("OTHER ERROR: " + error.toString());
  }
  return "";
}

Future<String> signIn(String user, String pass) async {
  try {
    await Firebase.initializeApp();
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: user, password: pass);
    print("SIGN IN UID: " + userCredential.user.uid);
    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } on PlatformException catch (e) {
    print("PLATFORM ERROR: " + e.toString());
  } catch (error) {
    print("OTHER ERROR: " + error.toString());
  }
  return "";
}

Future<String> postUser(String uid, String fName, String lName, String uName,
    {int numViews = 0, int numKredits = 0}) async {
  var response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "fName": fName,
      "lName": lName,
      "uName": uName,
      "numViews": numViews.toString(),
      "numKredits": numKredits.toString(),
    };
    String reqString = Constants.nodeURL + "users";
    print("Sending Request To: " + reqString);
    response = await http.post(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);
      if (response.body is String) return "Hello";
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error!" + err.toString());
  }
  return "";
}

Future<Map<String, dynamic>> getUser(String uid) async {
  var response;
  try {
    Map<String, String> params = {
      "uid": uid,
    };
    String reqString = Constants.nodeURL + "users";
    print("Sending Request To: " + reqString);
    response = await http.get(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);

      return jsonDecode(response.body);
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! => " + err.toString());
  }
  return null;
}
