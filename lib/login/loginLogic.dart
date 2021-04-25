import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;

import '../currentUser.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Dio dio = new Dio();

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

Future<String> checkIfUserIsSignedIn() async {
  try {
    await Firebase.initializeApp();
    User firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('User is currently signed out!');
      return "UserNotSignedIn";
    } else {
      print('User is signed in!');
      return "UserSignedIn";
    }
  } catch (err) {
    print("Ran Into Error! checkIfUserIsSignedIn => " + err.toString());
    return "ErrorOccuredOnTryCatch";
  }
  //return "ErrorOccuredGeneric";
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

Future<String> signOutUser() async {
  await Firebase.initializeApp();
  FirebaseAuth.instance.signOut().catchError((err) {
    if (err) {
      print("Ran Into Error! signOutUser => " + err.toString());
      return "ERROR";
    }
  });
  return "SignOutSucessful";
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

// ignore: missing_return
Future<String> signIn(BuildContext ctx, String user, String pass) async {
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: user, password: pass).catchError((err, stackTrace) {
    if (err.code == 'user-not-found') {
      showError(ctx, 'No user found for that email.');
    } else if (err.code == 'wrong-password') {
      showError(ctx, 'Wrong password provided for that user.');
    } else {
      showError(ctx, 'Unknown error occurred');
    }
    //consider funnier responses
    print(err.toString());
    return null;
  }).then((userCredential) {
    print("Signing in: " + userCredential.toString());
    if (userCredential != null) return userCredential;
  });
}

Future<void> resetPassword(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
}

Future<bool> doesUserExist(String email) async {
  Response response;
  try {
    Map<String, String> params = {
      "email": email,
    };

    String uri = Constants.nodeURL + "doesUserExist";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);

      if (response.data["status"] == "UserDoesNotExist")
        return false;
      else
        return true;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! doesUserExist => " + err.toString());
  }
  return null;
}

Future<String> postUser(String uid, String fName, String lName, String uName, String email, {int numViews = 0, int numKredits = 0}) async {
  Response response;
  try {
    Map<String, dynamic> params = {
      "uid": uid,
      "email": email,
      "fName": fName,
      "lName": lName,
      "uName": uName,
      "bio": "",
      "bioLink": "",
      "avatar": "",
      "numViews": numViews.toString(),
      "numKredits": numKredits.toString(),
      "following": [],
      "followers": [],
      "subscribing": [],
      "subscribers": [],
    };

    String uri = Constants.nodeURL + "postUser";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);

    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      if (response.data is String) return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! postUser => " + err.toString());
  }
  return "";
}

Future<Map<String, dynamic>> getUser(String uid) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid": uid,
    };
    String uri = Constants.nodeURL + "getUser";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! getUser => " + err.toString());
  }
  return null;
}

Future<void> setUpCurrentUserFromMongo(String uid) async {
  print("Setting up user from mongo");
  var user = await getUser(uid);
  print(user);
  currentUser.uid = uid;
  if (user != null) {
    currentUser.bio = user["bio"];
    currentUser.bioLink = user["bioLink"];
    currentUser.uName = user["uname"];
    currentUser.email = user["email"];
    currentUser.fName = user["fname"];
    currentUser.lName = user["lname"];
    currentUser.numViews = user["numviews"];
    currentUser.numKredits = user["numkredits"];
    currentUser.avatarLink = "https://avatars-klip.s3.amazonaws.com/" + uid + "_avatar.jpg";
    currentUser.userProfileImg = getProfileImage(uid + "_avatar.jpg", currentUser.avatarLink);
    try {
      for (uid in user["following"]) {
        currentUser.currentUserFollowing.add(uid);
      }
      for (uid in user["subscribing"]) {
        currentUser.currentUserSubscribing.add(uid);
      }
    } catch (err) {
      print("Ran Into Error! setUpCurrentUser => " + err.toString());
    }
  } else {
    print("Ran Into Error! setUpCurrentUser => ");
    print("USER IS NULL\nDid not set currentUser paramaters correctly");
  }
}

void setUpCurrentUserFromNewData(String uid, String bio, String uName, String email, String fName, String lName, String numViews, String numKredits) {
  print("Setting up user from new data");
  currentUser.uid = uid;
  currentUser.bio = bio;
  currentUser.bioLink = "";
  currentUser.uName = uName;
  currentUser.email = email;
  currentUser.fName = fName;
  currentUser.lName = lName;
  currentUser.numViews = numViews;
  currentUser.numKredits = numKredits;
  currentUser.avatarLink = "https://avatars-klip.s3.amazonaws.com/" + uid + "_avatar.jpg";
  currentUser.userProfileImg = getProfileImage(uid + "_avatar.jpg", currentUser.avatarLink);
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

Future<String> updateUsername(String uid, String uName) async {
  Response response;
  try {
    Map<String, String> params = {
      "uid": uid,
      "uName": uName,
    };
    String uri = Constants.nodeURL + "updateUsername";
    print("Sending Request To: " + uri);
    response = await dio.post(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);
      if (response.data is String) return response.data;
    } else {
      print("Returned error " + response.statusCode.toString());
      return "Error";
    }
  } catch (err) {
    print("Ran Into Error! postUser => " + err.toString());
  }
  return "";
}

Future<bool> doesUsernameExist(String username) async {
  Response response;
  try {
    Map<String, String> params = {
      "uname": username,
    };
    String uri = Constants.nodeURL + "doesUsernameExist";
    print("Sending Request To: " + uri);
    response = await dio.get(uri, queryParameters: params);
    if (response.statusCode == 200) {
      print("Returned 200");
      print(response.data);

      if (response.data["status"] == "UsernameDoesNotExist")
        return false;
      else
        return true;
    } else {
      print("Returned error " + response.statusCode.toString());
      return null;
    }
  } catch (err) {
    print("Ran Into Error! doesUserExist => " + err.toString());
  }
  return null;
}
