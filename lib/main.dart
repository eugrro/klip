import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klip/TopNavBar.dart';
import 'TopSection.dart';
import './Constants.dart' as Constants;
import 'package:klip/Pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klips',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int pagePosition = 0;
  ValueNotifier pageValueNotifier = ValueNotifier(0);
  PageController pageController;
  double _leftPadding;
  double _rightPadding;
  int navBarIndex;

  callback(newPagePosition) {
    setState(() {
      pagePosition = newPagePosition;
      pageController.jumpToPage(pagePosition);
    });
  }

  @override
  void initState() {
    pageController = new PageController(initialPage: 0);
    navBarIndex = 0;
    _leftPadding = window.physicalSize.width / window.devicePixelRatio / 8;
    _rightPadding = window.physicalSize.width / window.devicePixelRatio / 8 * 5;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: OrientationBuilder(
        builder: (context, orientation) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                color: orientation == Orientation.portrait
                    ? Constants.backgroundBlack
                    : Colors.green,
                child: orientation == Orientation.portrait
                    ? Column(
                        children: [
                          TopSection(),
                          pagePosition == 0
                              ? TopNavBar(0, callback)
                              : pagePosition == 1
                                  ? TopNavBar(1, callback)
                                  : pagePosition == 2
                                      ? TopNavBar(2, callback)
                                      : TopNavBar(3, callback),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 10,
                            ),
                            //line of top part
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width / 8 * 7,
                              color: Constants.purpleColor,
                            ),
                          ),
                          // The main pages of the applicaiton
                          Pages(pagePosition, callback, pageController),
                          //bottom nav bar and animated line
                          AnimatedPadding(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            //curve: Curves.linear,
                            padding: EdgeInsets.only(
                                left: _leftPadding,
                                right: _rightPadding   ,
                                top: 15),
                            child: Container(
                              height: 2,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Constants.purpleColor,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 15,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left:
                                          MediaQuery.of(context).size.width / 8,
                                      right:
                                          MediaQuery.of(context).size.width / 8,
                                    ),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Icon(
                                        Icons.home,
                                        color: navBarIndex == 0
                                            ? Constants.purpleColor
                                            : Constants.backgroundWhite,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      navBarIndex = 0;
                                      _leftPadding =
                                          MediaQuery.of(context).size.width / 8;
                                      _rightPadding =
                                          MediaQuery.of(context).size.width /
                                              8 *
                                              5;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left:
                                          MediaQuery.of(context).size.width / 8,
                                      right:
                                          MediaQuery.of(context).size.width / 8,
                                    ),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Icon(
                                        Icons.person_outline,
                                        color: navBarIndex == 1
                                            ? Constants.purpleColor
                                            : Constants.backgroundWhite,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      navBarIndex = 1;
                                      _leftPadding =
                                          MediaQuery.of(context).size.width /
                                              8 *
                                              5;
                                      _rightPadding =
                                          MediaQuery.of(context).size.width / 8;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Container(
                        color: Colors.green,
                      ),
              ),
              /*bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Constants.backgroundBlack,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      title: Container(),
                      icon: Icon(
                        Icons.home,
                        color: navBarIndex == 0
                            ? Constants.purpleColor
                            : Constants.backgroundWhite,
                      ),
                    ),
                    BottomNavigationBarItem(
                      title: Container(),
                      icon: Icon(
                        Icons.settings,
                        color: navBarIndex == 1
                            ? Constants.purpleColor
                            : Constants.backgroundWhite,
                      ),
                    ),
                  ],
                  currentIndex: navBarIndex,
                  selectedItemColor: Constants.purpleColor,
                  onTap: (index) {
                    setState(() {
                      navBarIndex = index;
                    });
                  }),*/
            ),
          );
        },
      ),
    );
  }
}
/*      children: [
        Container(
          height: 30,
        ),
        Container(
          color: Colors.white,
          child: Text("HI"),
        ),
        TopSection(),
        TopNavBar(),
        SizedBox(
          height: 300.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Text("HI"),
              Text("HI"),
              Text("HI"),
            ],
          ),
        ),
        */
