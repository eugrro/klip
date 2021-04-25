import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import './Constants.dart' as Constants;
import 'TopSection.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int homePageSideScrollPosition = 1;

  callback(newPagePosition) {
    setState(() {
      homePageSideScrollPosition = newPagePosition;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundBlack,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TopSection(),
          Expanded(
            child: HomeTab(homePageSideScrollPosition, callback),
          ),
        ],
      ),
    );
  }
}
