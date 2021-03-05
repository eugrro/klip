import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/currentUser.dart' as currentUser;
import '../Constants.dart' as Constants;
import 'package:klip/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    Constants.statusBarHeight = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(
        top: Constants.statusBarHeight,
      ),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
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
                Container(
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
                Container(
                  height: 25,
                ),
                Container(
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
                Container(
                  height: 60,
                )
              ],
            ),
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
          ],
        ),
      ),
    );
  }
}
