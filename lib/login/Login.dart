import 'package:flutter/material.dart';
import 'package:klip/Navigation.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'loginLogic.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../HomeTabs.dart';
import '../TopNavBar.dart';
import '../TopSection.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PageController _loginFlowController;
  TextEditingController userNameController;
  TextEditingController passwordController;
  TextEditingController passwordConfirmController;

  double heightOfButtons = 45;

  int currentPage = 1;

  @override
  void initState() {
    _loginFlowController = PageController(
      initialPage: currentPage,
    );
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundBlack,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 25,
                ),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 172,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/logo100White.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              /*Text(
              "Log In",
              style: TextStyle(
                color: Constants.backgroundWhite,
                fontSize: 30,
              ),
            ),*/
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 50,
                ),
                child: Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                    color: Constants.purpleColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Container(
                height: 225,
                child: PageView(
                  //physics: NeverScrollableScrollPhysics(),
                  controller: _loginFlowController,
                  children: [
                    //==========================================================
                    //==========================================================
                    //==========================================================
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .7,
                            child: TextFormField(
                              cursorColor: Constants.purpleColor,
                              decoration: new InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 1,
                                  ),
                                ),
                                //errorBorder: InputBorder.none,
                                //disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  bottom: 0,
                                  top: 0,
                                  right: 15,
                                ),

                                labelText: "Username",
                                labelStyle: TextStyle(
                                  color: Constants.backgroundWhite,
                                  fontSize: 16 + Constants.textChange,
                                  height: 1.5,
                                ),
                              ),
                              controller: userNameController,
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 20 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                        //=============================================================================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .35 -
                                    10,
                                child: TextFormField(
                                  cursorColor: Constants.purpleColor,
                                  decoration: new InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                        width: 1,
                                      ),
                                    ),
                                    //errorBorder: InputBorder.none,
                                    //disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 15,
                                      bottom: 0,
                                      top: 0,
                                      right: 15,
                                    ),

                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      color: Constants.backgroundWhite,
                                      fontSize: 16 + Constants.textChange,
                                      height: 1.5,
                                    ),
                                  ),
                                  controller: passwordController,
                                  style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 20 + Constants.textChange,
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .35 -
                                    10,
                                child: TextFormField(
                                  cursorColor: Constants.purpleColor,
                                  decoration: new InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.purpleColor,
                                        width: 1,
                                      ),
                                    ),
                                    //errorBorder: InputBorder.none,
                                    //disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 15,
                                      bottom: 0,
                                      top: 0,
                                      right: 15,
                                    ),

                                    labelText: "Confirm",
                                    labelStyle: TextStyle(
                                      color: Constants.backgroundWhite,
                                      fontSize: 16 + Constants.textChange,
                                      height: 1.5,
                                    ),
                                  ),
                                  controller: passwordController,
                                  style: TextStyle(
                                    color: Constants.backgroundWhite,
                                    fontSize: 20 + Constants.textChange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  print("Signing Up with: " +
                                      userNameController.text);
                                  print("Signing Up with: " +
                                      passwordController.text);
                                  if (userNameController.text != null &&
                                      passwordController != null) {
                                    String uid = await signUp(
                                        userNameController.text,
                                        passwordController.text);
                                    if (uid != null) {
                                      currentUser.uid = uid;
                                      currentUser.fName = "Jon";
                                      currentUser.lName = "Snow";
                                      currentUser.uName = "jSnow123";
                                      currentUser.numKredits = 87;
                                      currentUser.numViews = 123;
                                      String ret = await postUser(
                                          uid, "Jon", "snow", "jSnow123",
                                          numViews: 123, numKredits: 87);
                                      print(ret);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Navigation()),
                                      );
                                    } else {
                                      throw "ERROR UID IS NULL";
                                    }
                                  }
                                },
                                child: Container(
                                  height: heightOfButtons,
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  decoration: BoxDecoration(
                                    color: Constants.purpleColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Constants.backgroundWhite,
                                        fontSize: 18 + Constants.textChange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  currentPage = 1;
                                  _loginFlowController.animateToPage(
                                    currentPage,
                                    curve: Curves.linearToEaseOut,
                                    duration: Duration(
                                      milliseconds: 600,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: heightOfButtons,
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  decoration: BoxDecoration(
                                    color: Constants.purpleColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: Constants.backgroundWhite,
                                        fontSize: 18 + Constants.textChange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //==========================================================
                    //==========================================================
                    //==========================================================
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .7,
                            child: TextFormField(
                              cursorColor: Constants.purpleColor,
                              decoration: new InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 1,
                                  ),
                                ),
                                //errorBorder: InputBorder.none,
                                //disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  bottom: 0,
                                  top: 0,
                                  right: 15,
                                ),

                                labelText: "Username",
                                labelStyle: TextStyle(
                                  color: Constants.backgroundWhite,
                                  fontSize: 16 + Constants.textChange,
                                  height: 1.5,
                                ),
                              ),
                              controller: userNameController,
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 20 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                        //=============================================================================
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .7,
                            child: TextFormField(
                              cursorColor: Constants.purpleColor,
                              decoration: new InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Constants.purpleColor,
                                    width: 1,
                                  ),
                                ),
                                //errorBorder: InputBorder.none,
                                //disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  bottom: 0,
                                  top: 0,
                                  right: 15,
                                ),

                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: Constants.backgroundWhite,
                                  fontSize: 16 + Constants.textChange,
                                  height: 1.5,
                                ),
                              ),
                              controller: passwordController,
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 20 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .15),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                currentPage = 2;
                                _loginFlowController.animateToPage(
                                  currentPage,
                                  curve: Curves.linearToEaseOut,
                                  duration: Duration(
                                    milliseconds: 600,
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Constants.backgroundWhite,
                                  fontSize: 12 + Constants.textChange,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  currentPage = 0;
                                  _loginFlowController.animateToPage(
                                    currentPage,
                                    curve: Curves.linearToEaseOut,
                                    duration: Duration(
                                      milliseconds: 600,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: heightOfButtons,
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  decoration: BoxDecoration(
                                    color: Constants.purpleColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Constants.backgroundWhite,
                                        fontSize: 18 + Constants.textChange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  print("Signing In with: " +
                                      userNameController.text);
                                  print("Signing In with: " +
                                      passwordController.text);
                                  if (userNameController.text != null &&
                                      passwordController != null) {
                                    String uid = await signIn(
                                        userNameController.text,
                                        passwordController.text);
                                    if (uid != null) {
                                      currentUser.uid = uid;
                                      var ret = await getUser(uid);
                                      currentUser.fName = ret["fname"];
                                      currentUser.lName = ret["lname"];
                                      currentUser.uName = ret["uname"];
                                      currentUser.numKredits =
                                          int.parse(ret["numkredits"]);
                                      currentUser.numViews =
                                          int.parse(ret["numviews"]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Navigation()),
                                      );
                                    } else {
                                      throw "ERROR UID IS NULL";
                                    }
                                  }
                                },
                                child: Container(
                                  height: heightOfButtons,
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  decoration: BoxDecoration(
                                    color: Constants.purpleColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: Constants.backgroundWhite,
                                        fontSize: 18 + Constants.textChange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //==========================================================
                    //==========================================================
                    //==========================================================
                    Container(
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: currentPage != 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 10,
                    right: 10,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * .2,
                        color: Constants.purpleColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 14 + Constants.textChange,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * .2,
                        color: Constants.purpleColor,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: currentPage != 2,
                child: Container(
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              print(signInWithGoogle());
                            },
                            child: Text(
                              "CLICK HERE TO SIGN IN WITH GOOGLE",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              signOutGoogle();
                            },
                            child: Text(
                              "CLICK HERE TO SIGN OUT WITH GOOGLE",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
