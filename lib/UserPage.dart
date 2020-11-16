import 'package:flutter/material.dart';
import 'package:klip/profileSettings.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'package:auto_size_text/auto_size_text.dart';
import 'HomeTabs.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';

class UserPage extends StatefulWidget {
  UserPage();

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      currentUser.uName,
                      style: TextStyle(
                        fontSize: 24 + Constants.textChange,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, SlideUpRoute(page: ProfileSettings()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 30,
                          ),
                          child: Icon(
                            Icons.settings,
                            color: Constants.backgroundWhite,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      currentUser.numViews.toString(),
                      style: TextStyle(
                        fontSize: 28 + Constants.textChange,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                    Text(
                      "views",
                      style: TextStyle(
                        fontSize: 14 + Constants.textChange,
                        color: Constants.backgroundWhite.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 65,
                  child: Image.asset("lib/assets/images/personOutline.png"),
                ),
                Column(
                  children: [
                    Text(
                      currentUser.numKredits.toString(),
                      style: TextStyle(
                        fontSize: 28 + Constants.textChange,
                        color: Constants.backgroundWhite,
                      ),
                    ),
                    Text(
                      "Kredits",
                      style: TextStyle(
                        fontSize: 14 + Constants.textChange,
                        color: Constants.backgroundWhite.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Text(
                currentUser.bio,
                style: TextStyle(
                  fontSize: 16 + Constants.textChange,
                  color: Constants.backgroundWhite,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kElevationToShadow[3],
                    color: Constants.purpleColor,
                  ),
                  child:
                      Center(child: Text("Follow", style: Constants.tStyle())),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kElevationToShadow[3],
                    color: Constants.purpleColor,
                  ),
                  child: Center(
                      child: Text("Subscribe", style: Constants.tStyle())),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width / 15 * 14,
                color: Constants.purpleColor,
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                vidListItem(),
                vidListItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget vidListItem() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 30,
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              height: 120,
              width: 220,
              color: Colors.indigo,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Container(
                  width: 135,
                  child: AutoSizeText(
                    'Woah what an epic video Title!',
                    style: Constants.tStyle(),
                    maxLines: 3,
                  ),
                ),
              ),
              Text(
                "104 Views",
                style: Constants.tStyle(fontSize: 13),
              ),
              Text(
                "13 Comments",
                style: Constants.tStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;
  SlideUpRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
