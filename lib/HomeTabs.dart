import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import 'package:toast/toast.dart';
import './Constants.dart' as Constants;
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
    return Expanded(
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
    );
  }
}

/**/
