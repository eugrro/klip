import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/AddNewText.dart';
import 'package:klip/HomePage.dart';
import 'package:klip/widgets.dart';
import './Constants.dart' as Constants;
import 'package:klip/currentUser.dart' as currentUser;
import 'AddNewImage.dart';
import 'AddNewKlip.dart';
import 'UserPage.dart';

int homePagePosition;
PageController homePageController;

class Navigation extends StatefulWidget {
  Navigation({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  bool addingNewContent = false;
  bool showNavigationIcons = true;
  @override
  void initState() {
    super.initState();
    homePagePosition = 0;
    homePageController = PageController(initialPage: homePagePosition);
  }

  @override
  Widget build(BuildContext context) {
    Constants.statusBarHeight = MediaQuery.of(context).padding.top;
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: homePageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomePage(),
                UserPage(currentUser.uid, null),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Constants.bottomNavBarHeight,
                width: MediaQuery.of(context).size.width,
                color: Constants.purpleColor.withOpacity(.2),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            homePagePosition = 0;
                          });
                          homePageController.animateToPage(homePagePosition, duration: Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        child: Icon(
                          Icons.home_outlined,
                          color: Constants.backgroundWhite.withOpacity(.6),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSnackbar(context, "In development");
                        },
                        child: Icon(
                          Icons.announcement_outlined,
                          color: Constants.backgroundWhite.withOpacity(.6),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTypePicker(context);
                          setState(() {
                            addingNewContent = !addingNewContent;
                            showNavigationIcons = !showNavigationIcons;
                          });
                        },
                        child: Icon(
                          Icons.add_box_outlined,
                          color: Constants.backgroundWhite.withOpacity(.6),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSnackbar(context, "In development");
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Constants.backgroundWhite.withOpacity(.6),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            homePagePosition = 1;
                          });
                          homePageController.animateToPage(homePagePosition, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
          ],
        ),
      ),
    );
  }

  void _showTypePicker(context) {
    double contentTypeHeight = 90;

    double largeText = 16 + Constants.textChange;
    double largeIcon = 35;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isDismissible: false,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          //height: MediaQuery.of(context).size.height / 3,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    //0000000000000000000000000000000000000000000000000000000000
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.graphic_eq_rounded,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Audio",
                                style: TextStyle(
                                  fontSize: largeText,
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
                        Navigator.push(context, SlideInRoute(page: AddNewImage(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallpaper,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Image",
                                style: TextStyle(
                                  fontSize: largeText,
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
                        Navigator.push(context, SlideInRoute(page: AddNewKlip(), direction: 0)).then((value) {
                          Navigator.pop(context);
                          setState(() {
                            addingNewContent = !addingNewContent;
                            showNavigationIcons = !showNavigationIcons;
                          });
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videogame_asset,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Klip",
                                style: TextStyle(
                                  fontSize: largeText,
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
                        Navigator.push(context, SlideInRoute(page: AddNewText(), direction: 0));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.short_text,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Text",
                                style: TextStyle(
                                  fontSize: largeText,
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
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width / 5 - 4,
                        height: contentTypeHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.poll,
                              color: Constants.purpleColor,
                              size: largeIcon,
                            ),
                            Container(
                              child: Text(
                                "Poll",
                                style: TextStyle(
                                  fontSize: largeText,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        addingNewContent = !addingNewContent;
                      });
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 150), () {
                        setState(() {
                          showNavigationIcons = !showNavigationIcons;
                        });
                      });
                    },
                    child: Container(
                      height: Constants.bottomNavBarHeight,
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 10 * 2,
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
                            color: Constants.purpleColor.withOpacity(.9),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Constants.backgroundWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
