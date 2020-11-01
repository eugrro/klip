import 'package:flutter/material.dart';
import './Constants.dart' as Constants;
import 'HomeTabs.dart';
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
  ValueNotifier pageValueNotifier = ValueNotifier(0);
  PageController tabController;
  callback(newPagePosition) {
    setState(() {
      tabPosition = newPagePosition;
      tabController.jumpToPage(tabPosition);
    });
  }

  @override
  void initState() {
    tabController = new PageController(initialPage: tabPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        children: [
          TopSection(),
          tabPosition == 0
              ? TopNavBar(0, callback)
              : tabPosition == 1
                  ? TopNavBar(1, callback)
                  : tabPosition == 2
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
          // The tabs under the main page
          HomeTabs(tabPosition, callback, tabController),
        ],
      ),
    );
  }
}
