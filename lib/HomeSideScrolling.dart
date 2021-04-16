import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klip/HomeTab.dart';
import 'package:klip/widgets.dart';
import 'package:toast/toast.dart';
import 'Constants.dart' as Constants;
import 'Notifiers.dart';

// ignore: must_be_immutable
class HomeTabs extends StatefulWidget {
  int pageNumber;
  ValueNotifier valueNotifier;
  Function(int) callback;
  HomeTabs(this.pageNumber, this.callback);
  @override
  _HomeTabsState createState() => _HomeTabsState(pageNumber, callback);
}

class _HomeTabsState extends State<HomeTabs> {
  int pageNumber;
  ValueNotifier valueNotifier;

  Function(int) callback;

  _HomeTabsState(this.pageNumber, this.callback);

  HomeScrollValueNotifier notif = HomeScrollValueNotifier();
  PageController pageScroll;
  BuildContext ctx;
  @override
  void initState() {
    pageScroll = notif.getPageScroll();
    pageScroll.addListener(() {
      notif.update(pageScroll.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    //_pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Expanded(
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
            HomeTab(),
            Container(
              color: Constants.backgroundBlack,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.orange,
            ),
          ],
        ),
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
