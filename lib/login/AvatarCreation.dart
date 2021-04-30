import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klip/Navigation.dart';
import 'package:klip/login/SignIn.dart';
import 'package:klip/login/SignUp.dart';
import 'package:klip/widgets.dart';
import '../Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'loginLogic.dart';
import '../TopNavBar.dart';
import '../TopSection.dart';

class AvatarCreation extends StatefulWidget {
  @override
  _AvatarCreationState createState() => _AvatarCreationState();
}

class _AvatarCreationState extends State<AvatarCreation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                body: Stack(children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.9, 0.4, 0.5, 0.9],
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
                    "lib/assets/iconsUI/geometricLines3.png",
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height / 2.5,
                    fit: BoxFit.fill,
                    //color: Colors.grey,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20)),
                    Text("Pick an Avatar",
                        overflow: TextOverflow.visible, style: TextStyle(color: Constants.backgroundWhite, fontSize: 32 + Constants.textChange)),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20)),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {},
                        child: Stack(alignment: AlignmentDirectional.center, children: [
                          Container(
                            width: MediaQuery.of(context).size.height / 4,
                            child: ClipOval(
                              child: FutureBuilder<Widget>(
                                future: currentUser.userProfileImg, // a previously-obtained Future<String> or null
                                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data;
                                  } else {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: Stack(children: <Widget>[
                                          Opacity(opacity: .15, child: Container(child: Constants.tempAvatar)),
                                          Container(
                                              padding: EdgeInsets.only(top: 65, left: 70),
                                              child: Opacity(
                                                  opacity: 1,
                                                  child: Icon(Icons.camera_alt_outlined,
                                                      color: Constants.backgroundBlack, size: MediaQuery.of(context).size.height / 15)))
                                        ]));
                                  }
                                },
                              ),
                            ),
                          )
                        ])),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20)),
                    GestureDetector(
                        onTap: () async {},
                        child: Container(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .4,
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
                                "Skip",
                                style: TextStyle(
                                  color: Constants.backgroundWhite,
                                  fontSize: 32 + Constants.textChange,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ])))
            ]))));
  }
}
