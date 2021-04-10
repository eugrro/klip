import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:klip/currentUser.dart' as currentUser;

import '../currentUser.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
// ignore: non_constant_identifier_names
Widget LoginTextField(BuildContext context, double heightOfContainer, double borderThickness, double imgThickness, String hintText,
    TextEditingController contrl, Widget prefixIcon,
    {isObscured = false, isAutoFocus = false, FocusNode focusNode}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {},
    child: Container(
      width: MediaQuery.of(context).size.width * .8,
      height: heightOfContainer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(
          width: borderThickness,
          color: Constants.purpleColor.withOpacity(.8),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: heightOfContainer,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 9 / 10,
            decoration: BoxDecoration(
              color: Constants.backgroundBlack,
              borderRadius: new BorderRadius.all(Radius.circular(100)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 10 + imgThickness,
                right: 20, //+ imgThickness,
              ),
              child: TextField(
                autofocus: isAutoFocus,
                focusNode: focusNode != null ? focusNode : new FocusNode(),
                controller: contrl,
                keyboardType: TextInputType.multiline,
                obscureText: isObscured,
                //textAlign: TextAlign.center,
                cursorColor: Constants.backgroundWhite,
                cursorWidth: 1.5,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 0),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Constants.backgroundWhite.withOpacity(.6),
                    fontSize: 20 + Constants.textChange,
                  ),
                  //suffixIcon: postText(),
                ),
                style: TextStyle(
                  color: Constants.backgroundWhite.withOpacity(.9),
                  fontSize: 20 + Constants.textChange,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: heightOfContainer * .5 - imgThickness / 2 - borderThickness,
            ),
            child: Container(
              width: imgThickness,
              height: imgThickness,
              child: Center(child: prefixIcon),
            ),
          ),
        ],
      ),
    ),
  );
}

///Returns a list [uid, email] if sucessful otherwise ""
Future<dynamic> signInWithGoogle() async {
  try {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      print('signInWithGoogle succeeded: $user.uid');
      return [user.uid, user.email, user.displayName];
    }
  } on PlatformException catch (e) {
    print("PLATFORM ERROR: " + e.toString());
    return "";
  } catch (error) {
    print("OTHER ERROR: " + error.toString());
    return "";
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}

Future<String> signUp(String user, String pass) async {
  await Firebase.initializeApp();
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user, password: pass).catchError((e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    } else {
      print("OTHER ERROR: " + e.toString());
    }
  });
  print("SIGN UP UID: " + userCredential.user.uid);
  return userCredential.user.uid;
}

Future<String> signIn(String user, String pass) async {
  try {
    await Firebase.initializeApp();
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: user, password: pass);
    print("SIGN IN UID: " + userCredential.user.uid);
    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return "EmailNotFound";
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return "WrongPassword";
    }
  } on PlatformException catch (e) {
    print("PLATFORM ERROR: " + e.toString());
    return "ERROR";
  } catch (error) {
    print("OTHER ERROR: " + error.toString());
    return "ERROR";
  }
  return "";
}

Future<void> resetPassword(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
}

Future<bool> doesUserExist(String email) async {
  var response;
  try {
    Map<String, String> params = {
      "email": email,
    };
    String reqString = Constants.nodeURL + "doesUserExist";
    print("Sending Request To: " + reqString);
    response = await http.get(reqString, headers: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.body);

      if (response.body == "UserDoesNotExist")
        return false;
      else
        return true;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! => " + err.toString());
  }
  return null;
}

Future<String> postUser(String uid, String fName, String lName, String uName, String email, {int numViews = 0, int numKredits = 0}) async {
  var response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "email": email,
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
      if (response.body is String) return response.body;
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

void setUpCurrentUser(String uid) async {
  var user = await getUser(uid);
  currentUser.uid = uid;
  if (user != null) {
    currentUser.email = user["email"];
    currentUser.fName = user["fname"];
    currentUser.lName = user["lname"];
    currentUser.numViews = int.parse(user["numviews"]);
    currentUser.numKredits = int.parse(user["numkredits"]);
    currentUser.avatarLink = "https://avatars-klip.s3.amazonaws.com/" + uid + "_avatar.jpg";
    currentUser.userProfileImg = setProfileImage();
  } else {
    print("USER IS NULL did not set currentUser paramaters correctly");
  }
}

bool validinput(BuildContext ctx, String uName, String pass, String passConfirm) {
  bool valid = true;
  if (!uName.contains('@')) {
    valid = false;
    showError(ctx, "Invalid email");
  }
  if (!uName.contains('.')) {
    valid = false;
    showError(ctx, "Invalid email");
  }
  if (passConfirm != pass) {
    valid = false;
    showError(ctx, "Passwords do not match");
  }
  if (pass.length < 6) {
    valid = false;
    showError(ctx, "Password must be longer than 6 characters");
  }
  //TODO add actual input validation
  return valid;
}
