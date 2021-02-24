import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/AddNewText.dart';
import 'package:klip/HomePage.dart';
import 'package:klip/profileSettings.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'AddNewContent.dart';
import 'AddNewImage.dart';
import 'AddNewKlip.dart';
import 'HomeTabs.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';
import 'UserPage.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  int pagePosition = 0;

  PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: pagePosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        body: Stack(children: [
          PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              UserPage(currentUser.uid),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Constants.bottomNavBarHeight + 20,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width / 10 * 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3.1), // changes position of shadow
                      ),
                    ],
                    color: Constants.purpleColor.withOpacity(.3),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pagePosition = 0;
                            });
                            pageController.animateToPage(pagePosition,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: Icon(
                            Icons.home_outlined,
                            color: Constants.backgroundWhite.withOpacity(.6),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showTypePicker(context);
                          },
                          child: Icon(
                            Icons.add_box_outlined,
                            color: Constants.backgroundWhite.withOpacity(.6),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pagePosition = 1;
                            });

                            pageController.animateToPage(pagePosition,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          child: Icon(
                            Icons.person_outline_outlined,
                            color: Constants.backgroundWhite.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showTypePicker(context) {
    double contentTypeHeight = 90;

    double smallText = 13 + Constants.textChange;
    double largeText = 18 + Constants.textChange;
    double smallIcon = 20;
    double largeIcon = 40;
    double smallCircle = 15;
    double largeCircle = 25;

    int contentTypeSelected = 2;
    double circleThickness = 2;

    showModalBottomSheet(
        backgroundColor: Constants.backgroundBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    //0000000000000000000000000000000000000000000000000000000000
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          contentTypeSelected = 0;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Constants.hintColor,
                                radius: contentTypeSelected == 0
                                    ? largeCircle
                                    : smallCircle,
                                child: CircleAvatar(
                                  backgroundColor: Constants.backgroundBlack,
                                  radius: contentTypeSelected == 0
                                      ? largeCircle - circleThickness
                                      : smallCircle - circleThickness,
                                  child: Icon(
                                    Icons.all_inclusive,
                                    color: Constants.purpleColor,
                                    size: contentTypeSelected == 0
                                        ? largeIcon
                                        : smallIcon,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Audio",
                                style: TextStyle(
                                  fontSize: contentTypeSelected == 0
                                      ? largeText
                                      : smallText,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //1111111111111111111111111111111111111111111111111111111111
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          contentTypeSelected = 1;
                        });
                        Navigator.push(context,
                            SlideInRoute(page: AddNewImage(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Constants.hintColor,
                                radius: contentTypeSelected == 1
                                    ? largeCircle
                                    : smallCircle,
                                child: CircleAvatar(
                                  backgroundColor: Constants.backgroundBlack,
                                  radius: contentTypeSelected == 1
                                      ? largeCircle - circleThickness
                                      : smallCircle - circleThickness,
                                  child: Icon(
                                    Icons.public,
                                    color: Constants.purpleColor,
                                    size: contentTypeSelected == 1
                                        ? largeIcon
                                        : smallIcon,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: contentTypeSelected == 1
                                      ? largeText
                                      : smallText,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //2222222222222222222222222222222222222222222222222222222222
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          contentTypeSelected = 2;
                        });
                        Navigator.push(context,
                            SlideInRoute(page: AddNewKlip(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Constants.hintColor,
                                radius: contentTypeSelected == 2
                                    ? largeCircle
                                    : smallCircle,
                                child: CircleAvatar(
                                  backgroundColor: Constants.backgroundBlack,
                                  radius: contentTypeSelected == 2
                                      ? largeCircle - circleThickness
                                      : smallCircle - circleThickness,
                                  child: Icon(
                                    Icons.videogame_asset,
                                    color: Constants.purpleColor,
                                    size: contentTypeSelected == 2
                                        ? largeIcon
                                        : smallIcon,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "klip",
                                style: TextStyle(
                                  fontSize: contentTypeSelected == 2
                                      ? largeText
                                      : smallText,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //3333333333333333333333333333333333333333333333333333333333
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          contentTypeSelected = 3;
                        });
                        Navigator.push(context,
                            SlideInRoute(page: AddNewText(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Constants.hintColor,
                                radius: contentTypeSelected == 3
                                    ? largeCircle
                                    : smallCircle,
                                child: CircleAvatar(
                                  backgroundColor: Constants.backgroundBlack,
                                  radius: contentTypeSelected == 3
                                      ? largeCircle - circleThickness
                                      : smallCircle - circleThickness,
                                  child: Icon(
                                    Icons.short_text,
                                    color: Constants.purpleColor,
                                    size: contentTypeSelected == 3
                                        ? largeIcon
                                        : smallIcon,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Text",
                                style: TextStyle(
                                  fontSize: contentTypeSelected == 3
                                      ? largeText
                                      : smallText,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //4444444444444444444444444444444444444444444444444444444444
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          contentTypeSelected = 5;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Constants.hintColor,
                                radius: contentTypeSelected == 5
                                    ? largeCircle
                                    : smallCircle,
                                child: CircleAvatar(
                                  backgroundColor: Constants.backgroundBlack,
                                  radius: contentTypeSelected == 5
                                      ? largeCircle - circleThickness
                                      : smallCircle - circleThickness,
                                  child: Icon(
                                    Icons.poll,
                                    color: Constants.purpleColor,
                                    size: contentTypeSelected == 5
                                        ? largeIcon
                                        : smallIcon,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Poll",
                                style: TextStyle(
                                  fontSize: contentTypeSelected == 5
                                      ? largeText
                                      : smallText,
                                  color: Constants.backgroundWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
