import 'dart:math';

import 'package:flutter/material.dart';
import 'package:klip/Notifiers.dart';
import './Constants.dart' as Constants;
import 'HomeSideScrolling.dart';
import 'ScrollSnapList.dart';
import 'TopNavBar.dart';
import 'TopSection.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int tabPosition = 0;

  callback(newPagePosition) {
    setState(() {
      tabPosition = newPagePosition;
      //topDirect.animateTo(tabPosition);
    });
  }

  HomeScrollValueNotifier notif = HomeScrollValueNotifier();
  ScrollController headerScroll;
  int _focusedIndex = 0;

  @override
  void initState() {
    headerScroll = notif.getHeaderScroll();
    // headerScroll.addListener(() {
    //   print("CURRENT POSITION: " + headerScroll.offset.toString());
    //   notif.update(headerScroll.offset);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle st = TextStyle(
      color: Constants.backgroundWhite,
      fontSize: 16 + Constants.textChange,
    );
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        children: [
          TopSection(),
          /*Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .8,
              height: 50,
              child: ScrollSnapList(
                onItemFocus: (int index) {
                  setState(() {
                    _focusedIndex = index;
                  });
                  print("Currently Focused on: " + _focusedIndex.toString());
                },
                listController: headerScroll,
                initialIndex: 1,
                dynamicItemOpacity: .1,
                itemBuilder: (BuildContext ctx, int pos) {
                  return Container(
                    width: 100,
                    child: Center(
                      child: pos == 0
                          ? Text(
                              "Explore",
                              style: st,
                            )
                          : pos == 1
                              ? Text(
                                  "Explore",
                                  style: st,
                                )
                              : Text(
                                  "Explore",
                                  style: st,
                                ),
                    ),
                  );
                },
                itemCount: 3,
                itemSize: 100,
              ),
            ),
          ),*/
          // tabPosition == 0
          //     ? TopNavBar(0, callback)
          //     : tabPosition == 1
          //         ? TopNavBar(1, callback)
          //         : tabPosition == 2
          //             ? TopNavBar(2, callback)
          //             : TopNavBar(3, callback),
          Padding(
            padding: EdgeInsets.only(
              bottom: 0,
            ),
            //line of top part
            // child: Container(
            //   height: 2,
            //   width: MediaQuery.of(context).size.width / 8 * 7,
            //   color: Constants.purpleColor,
            // ),
          ),
          // The tabs under the main page
          HomeTabs(tabPosition, callback),
        ],
      ),
    );
  }
}
