import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import './Constants.dart' as Constants;
import 'TopSection.dart';

class HomePage extends StatefulWidget {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
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
