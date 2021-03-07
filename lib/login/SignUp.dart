import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/login/SignIn.dart';
import 'package:klip/login/SignUp.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'loginLogic.dart';
import '../HomeTabs.dart';
import '../TopNavBar.dart';
import '../TopSection.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController;
  TextEditingController passwordController;
  TextEditingController passwordConfirmController;

  double heightOfButtons = 45;

  int currentPage = 1;
  double heightOfContainer = 60;
  double borderThickness = 3;
  double imgThickness = 50;
  @override
  void initState() {
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: Constants.statusBarHeight,
        ),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.4, 0.5, 0.9],
                      colors: [
                        Constants.purpleColor,
                        Constants.purpleColor.withOpacity(.6),
                        Constants.purpleColor.withOpacity(.1),
                        Colors.transparent
                      ],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.srcIn,
                  child: Image.asset(
                    "lib/assets/iconsUI/geometricLines2.png",
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height / 2.5,
                    fit: BoxFit.fill,
                    //color: Colors.grey,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "lib/assets/iconsUI/Klip_Logo.svg",
                      semanticsLabel: 'commentIcon',
                      width: MediaQuery.of(context).size.width * .5,
                      height: 115,
                    ),
                  ),
                  Container(
                    height: 40,
                  ),
                  Column(
                    children: [
                      LoginTextField(
                        context,
                        heightOfContainer,
                        borderThickness,
                        imgThickness,
                        "Email",
                        userNameController,
                        SvgPicture.asset(
                          "lib/assets/iconsUI/personOutline.svg",
                          color: Constants.backgroundWhite.withOpacity(.9),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      LoginTextField(
                        context,
                        heightOfContainer,
                        borderThickness,
                        imgThickness,
                        "Password",
                        passwordController,
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Constants.backgroundWhite.withOpacity(.9),
                        ),
                        isObscured: true,
                      ),
                      Container(
                        height: 20,
                      ),
                      LoginTextField(
                        context,
                        heightOfContainer,
                        borderThickness,
                        imgThickness,
                        "Confirm Password",
                        passwordConfirmController,
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Constants.backgroundWhite.withOpacity(.9),
                        ),
                        isObscured: true,
                      ),
                      Container(
                        height: 35,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Navigation()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: heightOfContainer - 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Constants.purpleColor, Color(0xffab57a8)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Constants.backgroundWhite,
                                fontSize: 24 + Constants.textChange,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: .3,
                        width: MediaQuery.of(context).size.width * .3,
                        color: Constants.purpleColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 16 + Constants.textChange,
                          ),
                        ),
                      ),
                      Container(
                        height: .3,
                        width: MediaQuery.of(context).size.width * .3,
                        color: Constants.purpleColor,
                      ),
                    ],
                  ),
                  Container(
                    height: 25,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "lib/assets/images/facebookIcon.png",
                          height: 50,
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle();
                          },
                          child: Image.asset(
                            "lib/assets/images/googleIcon.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 16 + Constants.textChange,
                          ),
                        ),
                        Text(
                          "Sign In",
                          style: TextStyle(
                            color: Constants.purpleColor,
                            fontSize: 16 + Constants.textChange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
