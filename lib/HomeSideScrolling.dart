import 'package:flutter/material.dart';
import 'package:klip/ContentWidget.dart';
import 'package:klip/UserPage.dart';
import './Constants.dart' as Constants;
import 'package:klip/commentsPage.dart';
import 'package:klip/widgets.dart';

// ignore: must_be_immutable
class HomeSideScrolling extends StatefulWidget {
  int homePageSideScrollPosition;
  dynamic content;
  Function(int) callback;
  HomeSideScrolling(this.homePageSideScrollPosition, this.callback, this.content);
  @override
  _HomeSideScrollingState createState() => _HomeSideScrollingState(homePageSideScrollPosition, callback, content);
}

class _HomeSideScrollingState extends State<HomeSideScrolling> {
  int homePageSideScrollPosition;
  ValueNotifier valueNotifier;
  dynamic content;
  Function(int) callback;

  _HomeSideScrollingState(this.homePageSideScrollPosition, this.callback, this.content);

  PageController pageScroll;
  BuildContext ctx;
  @override
  void initState() {
    pageScroll = PageController(initialPage: homePageSideScrollPosition);
    super.initState();
  }

  callback2(newPagePosition) {
    setState(() {
      pageScroll.animateToPage(newPagePosition, duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
    callback(newPagePosition);
  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (content == null || content == {} || content["pid"] == null || content["pid"] == '' || content["pid"] == "") {
      return Center(
        child: Text(
          "Error loading Content",
          style: TextStyle(color: Constants.backgroundWhite),
        ),
      );
    }
    ctx = context;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: pageScroll,
        /*onPageChanged: (newPage) {
          setState(() {
            pageNumber = newPage;
            widget.callback(pageNumber);
          });
        },*/
        children: <Widget>[
          CommentsPage(content["pid"], content["comm"], callback2),
          ContentWidget(content, callback2),
          UserPage(content["uid"], callback2, true),
        ],
      ),
    );
  }

  DateTime currentBackPressTime;
  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      showSnackbar(ctx, "Press back again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
