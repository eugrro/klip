import 'package:flutter/material.dart';
import 'package:klip/HomeTab.dart';
import 'package:toast/toast.dart';

class Pages extends StatefulWidget {
  int pageNumber;
  ValueNotifier valueNotifier;
  PageController pageController;
  Function(int) callback;
  Pages(this.pageNumber, this.callback, this.pageController);
  @override
  _PagesState createState() =>
      _PagesState(pageNumber, callback, pageController);
}

class _PagesState extends State<Pages> {
  int pageNumber;
  ValueNotifier valueNotifier;
  PageController _pageController;
  Function(int) callback;
  _PagesState(this.pageNumber, this.callback, this._pageController);

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
