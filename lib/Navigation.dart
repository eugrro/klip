import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/HomePage.dart';
import 'package:klip/profileSettings.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
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

  double _leftPadding;
  double _rightPadding;

  @override
  void initState() {
    pageController = PageController(initialPage: pagePosition);
    _leftPadding = window.physicalSize.width / window.devicePixelRatio / 12;
    _rightPadding =
        window.physicalSize.width / window.devicePixelRatio / 12 * 9;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              UserPage(),
            ],
          ),
          bottomNavigationBar: Container(
            height: Constants.bottomNavBarHeight,
            color: Constants.backgroundBlack,
            child: Column(
              children: [
                AnimatedPadding(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  //curve: Curves.linear,
                  padding: EdgeInsets.only(
                      left: _leftPadding, right: _rightPadding, top: 8),
                  child: Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width / 6,
                    color: Constants.purpleColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Icon(
                              Icons.home,
                              color: pagePosition == 0
                                  ? Constants.purpleColor
                                  : Constants.backgroundWhite,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            pagePosition = 0;
                            pageController.animateToPage(pagePosition,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                            _leftPadding =
                                MediaQuery.of(context).size.width / 12;
                            _rightPadding =
                                MediaQuery.of(context).size.width / 12 * 9;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 3,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Icon(
                              Icons.add,
                              color: pagePosition == -1
                                  ? Constants.purpleColor
                                  : Constants.backgroundWhite,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            pagePosition = -1;
                            _leftPadding =
                                MediaQuery.of(context).size.width / 12 * 5;
                            _rightPadding =
                                MediaQuery.of(context).size.width / 12 * 5;
                          });
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewContent()),
                          );*/
                          _showTypePicker(context);
                        },
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 3 * 2,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Icon(
                              Icons.person_outline,
                              color: pagePosition == 1
                                  ? Constants.purpleColor
                                  : Constants.backgroundWhite,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            pagePosition = 1;
                            pageController.animateToPage(pagePosition,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                            _leftPadding =
                                MediaQuery.of(context).size.width / 12 * 9;
                            _rightPadding =
                                MediaQuery.of(context).size.width / 12;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
