import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import './loginLogic.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'Pages.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PageController _loginFlowController;
  TextEditingController userNameController;
  TextEditingController passwordController;

  @override
  void initState() {
    _loginFlowController = PageController(
      initialPage: 1,
    );
    passwordController = TextEditingController();
    userNameController = TextEditingController();
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
                    Container(
                      color: Colors.blue,
                    ),
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
                          padding: const EdgeInsets.only(
                            top: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * .35,
                                decoration: BoxDecoration(
                                  color: Constants.purpleColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    signUp(userNameController.text,
                                        passwordController.text);
                                    /*_loginFlowController.animateToPage(
                                      0,
                                      curve: Curves.linearToEaseOut,
                                      duration: Duration(
                                        milliseconds: 600,
                                      ),
                                    );*/
                                  },
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
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * .35,
                                decoration: BoxDecoration(
                                  color: Constants.purpleColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    print("Signing In with: " +
                                        userNameController.text);
                                    print("Signing In with: " +
                                        passwordController.text);
                                    signIn(userNameController.text,
                                        passwordController.text);
                                  },
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

                        Container(
                          color: Colors.green,
                        )
                      ],
                    ),
                    Container(
                      color: Colors.green,
                    )
                  ],
                ),
              ),
              Padding(
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
              Column(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
