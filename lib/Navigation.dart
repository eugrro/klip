import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/HomePage.dart';
import './Constants.dart' as Constants;
import 'AddNewContent.dart';
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
    pageController = new PageController(
      initialPage: pagePosition,
    );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewContent()),
                          );
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
}
