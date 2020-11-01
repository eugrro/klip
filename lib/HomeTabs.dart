import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class HomeTabs extends StatefulWidget {
  int pageNumber;
  ValueNotifier valueNotifier;
  PageController pageController;
  Function(int) callback;
  HomeTabs(this.pageNumber, this.callback, this.pageController);
  @override
  _HomeTabsState createState() =>
      _HomeTabsState(pageNumber, callback, pageController);
}

class _HomeTabsState extends State<HomeTabs> {
  int pageNumber;
  ValueNotifier valueNotifier;
  PageController _pageController;
  Function(int) callback;
  _HomeTabsState(this.pageNumber, this.callback, this._pageController);

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
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            pageNumber = newPage;
            widget.callback(pageNumber);
          });
        },
        children: <Widget>[
          HomeTab(),
          Container(
            color: Colors.blue,
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
