import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/currentUser.dart' as currentUser;
import 'package:klip/login/loginLogic.dart';
import '../Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../currentUser.dart';
import 'SignIn.dart';
import 'SignUp.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkIfUserIsSignedIn(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == "UserSignedIn") {
              //setUpCurrentUser(uid);
              pullUserFromSharedPreferences();
              return Navigation();
            } else {
              print("DATA " + snapshot.data.toString());
              return startScreen();
            }
          } else {
            return Center(
              child: Container(),
            );
          }
        });
  }

  Widget startScreen() {
    Constants.statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
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
                    colors: [Constants.purpleColor, Constants.purpleColor.withOpacity(.6), Constants.purpleColor.withOpacity(.1), Colors.transparent],
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
                    width: MediaQuery.of(context).size.width * .75,
                    height: 150,
                  ),
                ),
                Container(
                  height: 50,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
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
                        style: TextStyle(color: Constants.backgroundWhite, fontSize: 24 + Constants.textChange),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 25,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      border: Border.all(
                        width: 3,
                        color: Constants.purpleColor.withOpacity(.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Constants.purpleColor, fontSize: 24 + Constants.textChange),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
