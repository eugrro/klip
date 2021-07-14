import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'loginLogic.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController;
  TextEditingController passwordController;

  double heightOfButtons = 45;

  int currentPage = 1;
  double heightOfContainer = 60;
  double borderThickness = 3;
  double imgThickness = 50;
  @override
  void initState() {
    passwordController = TextEditingController();
    emailController = TextEditingController();
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
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
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
                    child:
                        klipLogo(115, MediaQuery.of(context).size.width * .5),
                  ),
                  Container(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Enter your Email to reset your password",
                      style: TextStyle(
                        color: Constants.backgroundWhite,
                        fontSize: 16 + Constants.textChange,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Column(
                    children: [
                      LoginTextField(
                        context,
                        heightOfContainer,
                        borderThickness,
                        imgThickness,
                        "Email",
                        emailController,
                        Icon(
                          Icons.mail_outline,
                          color: Constants.backgroundWhite.withOpacity(.9),
                        ),
                      ),
                      Container(
                        height: 25,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          print(
                              "Resetting password for email ${emailController.text}...");
                          resetPassword(emailController.text).then((value) {
                            print("Password reset email sent.");
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          height: heightOfContainer - 10,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Constants.purpleColor,
                                Color(0xffab57a8)
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Reset",
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
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your account? ",
                          style: TextStyle(
                            color: Constants.backgroundWhite,
                            fontSize: 16 + Constants.textChange,
                          ),
                        ),
                        Text(
                          "Go Back",
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
