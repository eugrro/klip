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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        children: [
          TopSection(),
          HomeTabs(tabPosition, callback),
        ],
      ),
    );
  }
}
