import 'dart:io';
import 'dart:ui';
// import "package:theme_provider/theme_provider.dart";
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/login/loginLogic.dart';
import '../Constants.dart' as Constants;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/currentUser.dart' as currentUser;
import '../currentUser.dart';
import 'SignIn.dart';
import 'SignUp.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  AsyncMemoizer _memoizer;
  void setUpPreferences() async {
    await pullUserFromSharedPreferences();
    //ThemeProvider.controllerOf(context).setTheme(currentUser.themePreference);
  }

  @override
  void initState() {
    setUpPreferences();
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _memoizer.runOnce(() async {
        return await checkIfUserIsSignedIn();
      }), // checkIfUserIsSignedIn(),
      // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == "UserSignedIn") {
            //setUpCurrentUser(uid);
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
      },
    );
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
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [.3, .8],
                      colors: [
                        Constants.backgroundWhite,
                        Constants.purpleColor,
                      ],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.srcIn,
                  child: Center(
                    child: Image.asset(
                      "lib/assets/images/KlipLogo.png",
                      width: MediaQuery.of(context).size.width * .75,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
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
